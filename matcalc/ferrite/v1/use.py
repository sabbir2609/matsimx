from pymatgen.core import Structure, Element
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer
import itertools, os

# ---- EDIT: point to your cif/vasp file ----
INPUT_FILE = "Zn(FeO2)2_fd3m.cif"


# ---- helpers ----
def site_is(site, sym):
    """Return True if site contains element with symbol `sym` (handles single and mixed sites)."""
    try:
        return site.specie.symbol == sym
    except Exception:
        # mixed occupancy: site.species is a dict-like
        return any(sp.symbol == sym for sp in site.species.keys())


def canonical_key(structure, ndigits=6):
    """A deterministic, permutation-invariant representation for a structure (species + frac coords rounded)."""
    keys = []
    for site in structure:
        sp = site.species_string  # e.g., "Zn" or "Fe"
        x, y, z = site.frac_coords
        keys.append((sp, round(x, ndigits), round(y, ndigits), round(z, ndigits)))
    keys.sort()
    return tuple(keys)


def enumerate_subs(
    base_struct, target_symbol, replacement_symbol, n_replace, max_out=None
):
    """Enumerate all unique structures replacing n_replace sites of target_symbol -> replacement_symbol."""
    indices = [i for i, s in enumerate(base_struct) if site_is(s, target_symbol)]
    unique = {}
    for comb in itertools.combinations(indices, n_replace):
        s = base_struct.copy()
        for idx in comb:
            s[idx] = Element(replacement_symbol)
        key = canonical_key(s)
        if key not in unique:
            unique[key] = {"structure": s, "indices": comb}
            if max_out and len(unique) >= max_out:
                break
    return unique


# ---- load structure ----
struct = Structure.from_file(INPUT_FILE)
print("Loaded structure with formula:", struct.composition.reduced_formula)
print("Total sites:", len(struct))

# optional: print symmetry groups (helps understand equivalences)
sga = SpacegroupAnalyzer(struct, symprec=1e-3)
symm = sga.get_symmetrized_structure()
print("Number of symmetry-equivalent groups:", len(symm.equivalent_indices))

os.makedirs("case1", exist_ok=True)
os.makedirs("case2", exist_ok=True)
os.makedirs("case3", exist_ok=True)

# ---- Case 1: MnZnFe2O4  -> replace 4 Zn with Mn (Zn8 -> Mn4 Zn4) ----
print("\nEnumerating Case 1: replace 4 Zn -> Mn")
case1 = enumerate_subs(struct, target_symbol="Zn", replacement_symbol="Mn", n_replace=4)
print("Unique configs (case1):", len(case1))
for i, (key, val) in enumerate(case1.items(), 1):
    fname = f"case1_MnZnFe2O4_config_{i}_Znidx_{'_'.join(map(str, val['indices']))}.cif"
    val["structure"].to(filename=os.path.join("case1", fname))

# ---- Case 2: Mn0.2Zn0.8Fe2O4 -> replace 2 Zn with Mn (Zn8 -> Mn2 Zn6) ----
print("\nEnumerating Case 2: replace 2 Zn -> Mn")
case2 = enumerate_subs(struct, target_symbol="Zn", replacement_symbol="Mn", n_replace=2)
print("Unique configs (case2):", len(case2))
for i, (key, val) in enumerate(case2.items(), 1):
    fname = f"case2_Mn0.2Zn0.8Fe2O4_config_{i}_Znidx_{'_'.join(map(str, val['indices']))}.cif"
    val["structure"].to(filename=os.path.join("case2", fname))

# ---- Case 3: Mn0.2Zn0.8La0.01Fe1.99O4 -> combine case2 Zn-configs with single Fe->La substitutions ----
print("\nEnumerating Case 3: combine 2 Zn->Mn + 1 Fe->La")
fe_indices = [i for i, s in enumerate(struct) if site_is(s, "Fe")]

case3 = {}
for ck, cv in case2.items():  # cv is a dict with 'structure' and 'indices' (Zn indices)
    base = cv["structure"]
    zn_idxs = cv["indices"]
    for fe_idx in fe_indices:
        s = base.copy()
        s[fe_idx] = Element("La")
        key = canonical_key(s)
        if key not in case3:
            case3[key] = {"structure": s, "zn_indices": zn_idxs, "fe_index": fe_idx}

print("Unique configs (case3):", len(case3))
for i, (key, val) in enumerate(case3.items(), 1):
    fname = f"case3_Mn0.2Zn0.8La0.01_cfg_{i}_Zn_{'_'.join(map(str, val['zn_indices']))}_Fe_{val['fe_index']}.cif"
    val["structure"].to(filename=os.path.join("case3", fname))

print("\nDone. CIFs written to ./case1, ./case2, ./case3")

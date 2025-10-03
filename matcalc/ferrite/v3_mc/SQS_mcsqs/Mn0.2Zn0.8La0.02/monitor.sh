#!/bin/bash

# ATAT MCSQS Run with Integrated Progress Monitoring
# Auto-generated script with embedded file creation
# Generated configuration: 1_POSCAR-0.125, 2×2×1, 224 atoms

# --- Configuration ---
LOG_FILE="mcsqs1.log"
PROGRESS_FILE="mcsqs_parallel_progress.csv"
DEFAULT_MCSQS_ARGS="-rc"

# --- Auto-generate ATAT Input Files ---
create_input_files() {
   echo "Creating ATAT input files..."

   cat > rndstr.in << 'EOF'
1.000000 1.000000 0.577350 90.00 90.00 109.47
1 0 0
0 1 0
0 0 1
0.125000 0.375000 1.000000 Mn=1.000000
0.125000 0.875000 0.500000 Mn=1.000000
0.625000 0.875000 1.000000 Mn=1.000000
0.250000 0.750000 1.000000 Mn=1.000000
0.750000 0.750000 0.500000 Mn=1.000000
0.750000 0.250000 0.000000 Mn=1.000000
0.250000 0.250000 0.500000 Mn=1.000000
0.625000 0.375000 0.500000 Zn=1.000000
0.937500 0.062500 0.750000 Fe=0.875000,La=0.125000
0.437500 0.062500 0.250000 Fe=1.000000
0.437500 0.562500 0.750000 Fe=0.875000,La=0.125000
0.937500 0.562500 0.250000 Fe=1.000000
0.687500 0.062500 0.500000 Fe=1.000000
0.187500 0.062500 0.000000 Fe
0.187500 0.562500 0.500000 Fe=1.000000
0.687500 0.562500 0.000000 Fe
0.437500 0.062500 0.750000 Fe=1.000000
0.937500 0.062500 0.250000 Fe=0.875000,La=0.125000
0.937500 0.562500 0.750000 Fe=1.000000
0.437500 0.562500 0.250000 Fe=0.875000,La=0.125000
0.937500 0.312500 0.500000 Fe=1.000000
0.437500 0.312500 0.000000 Fe
0.437500 0.812500 0.500000 Fe=1.000000
0.937500 0.812500 0.000000 Fe
0.817334 0.452004 0.000000 O
0.317335 0.452004 0.500000 O
0.317334 0.952004 1.000000 O
0.817334 0.952004 0.500000 O
0.547996 0.182665 0.000000 O
0.047996 0.182665 0.500000 O
0.047996 0.682665 1.000000 O
0.547996 0.682666 0.500000 O
0.817335 0.182665 0.730662 O
0.317334 0.182666 0.230662 O
0.317334 0.682666 0.730662 O
0.817334 0.682666 0.230662 O
0.057666 0.442335 0.730662 O
0.557665 0.442335 0.230662 O
0.557665 0.942335 0.730662 O
0.057665 0.942335 0.230662 O
0.057666 0.442335 0.269338 O
0.557665 0.442335 0.769338 O
0.557665 0.942335 0.269338 O
0.057665 0.942335 0.769338 O
0.327003 0.442335 1.000000 O
0.827003 0.442335 0.500000 O
0.827003 0.942335 1.000000 O
0.327003 0.942335 0.500000 O
0.817335 0.182665 0.269338 O
0.317334 0.182666 0.769338 O
0.317334 0.682666 0.269338 O
0.817334 0.682666 0.769338 O
0.057665 0.172997 1.000000 O
0.557665 0.172997 0.500000 O
0.557665 0.672997 1.000000 O
0.057665 0.672997 0.500000 O
EOF

   cat > sqscell.out << 'EOF'
1

2 0 0
0 2 0
0 0 1
EOF

   echo "✅ Input files created: rndstr.in, sqscell.out"
}

# --- Monitoring Functions ---

extract_latest_objective() {
   grep "Objective_function=" "$1" | tail -1 | sed 's/.*= *//' 2>/dev/null || echo ""
}

extract_latest_step() {
   grep -c "Objective_function=" "$1" 2>/dev/null || echo "0"
}

extract_latest_correlation() {
   grep "Correlations_mismatch=" "$1" | tail -1 | sed 's/.*= *//' | awk '{print $1}' 2>/dev/null || echo ""
}

count_correlations() {
   grep "Correlations_mismatch=" "$1" | tail -1 | awk -F'\t' '{print NF-1}' 2>/dev/null || echo "0"
}

is_mcsqs_running() {
   pgrep -f "mcsqs" > /dev/null
   return $?
}

start_parallel_monitoring_process() {
   local output_file="$1"
   local minute=0

   echo "Monitor started for 4 parallel runs. Waiting for 5 seconds to allow mcsqs to initialize..."
   sleep 5

   header="Minute,Timestamp"
   for i in $(seq 1 4); do
       header="$header,Run${i}_Steps,Run${i}_Objective,Run${i}_Status"
   done
   header="$header,Best_Overall_Objective,Best_Run"
   echo "$header" > "$output_file"

   echo "----------------------------------------"
   echo "Monitoring 4 parallel MCSQS runs every minute"
   echo "Log files: mcsqs1.log, mcsqs2.log, ..., mcsqs4.log"
   echo "----------------------------------------"

   while true; do
       minute=$((minute + 1))
       local current_time=$(date +"%m/%d/%Y %H:%M")

       row_data="$minute,$current_time"
       best_objective=""
       best_run=""
       any_running=false

       for i in $(seq 1 4); do
           local log_file="mcsqs${i}.log"
           local objective="N/A"
           local step_count="0"
           local status="STOPPED"

           if pgrep -f "mcsqs.*-ip=${i}" > /dev/null; then
               status="RUNNING"
               any_running=true
           fi

           if [ -f "$log_file" ]; then
               objective=$(extract_latest_objective "$log_file")
               step_count=$(extract_latest_step "$log_file")
               objective=${objective:-"N/A"}
               step_count=${step_count:-"0"}
           fi

           row_data="$row_data,$step_count,$objective,$status"

           if [ "$objective" != "N/A" ] && [ -n "$objective" ]; then
               if [ -z "$best_objective" ] || awk "BEGIN {exit !($objective < $best_objective)}" 2>/dev/null; then
                   best_objective="$objective"
                   best_run="Run$i"
               fi
           fi
       done

       best_objective=${best_objective:-"N/A"}
       best_run=${best_run:-"N/A"}
       row_data="$row_data,$best_objective,$best_run"

       echo "$row_data" >> "$output_file"

       printf "Minute %3d | Active runs: " "$minute"
        for i in $(seq 1 4); do
            if pgrep -f "mcsqs.*-ip=${i}" > /dev/null; then
                printf "R%d " "$i"
            else
                printf "%s " "--"  
            fi
        done
        printf "| Best: %s (%s)\n" "$best_objective" "$best_run"

       if [ "$any_running" = false ]; then
           echo "All parallel runs stopped. Collecting final data..."
           break
       fi

       sleep 60
   done

   echo "----------------------------------------"
   echo "Parallel monitoring process finished."
}

# --- Main Script Logic ---

check_prerequisites() {
   echo "Checking prerequisites..."

   create_input_files

   echo "Generating clusters with corrdump..."
   echo "Command: corrdump -l=rndstr.in -ro -noe -nop -clus -2=3.0000000000000018 -3=1.0"
   corrdump -l=rndstr.in -ro -noe -nop -clus -2=3.0000000000000018 -3=1.0
   if [ $? -ne 0 ]; then
       echo "ERROR: corrdump command failed!"
       exit 1
   fi
   echo "✅ Clusters generated successfully."
   echo "✅ All prerequisites satisfied."
}

cleanup() {
   echo ""
   echo "Interrupt signal received. Cleaning up background processes..."
   if [ -n "$MCSQS_PID" ]; then kill "$MCSQS_PID" 2>/dev/null; fi
   if [ -n "$MONITOR_PID" ]; then kill "$MONITOR_PID" 2>/dev/null; fi
   pkill -f "mcsqs" 2>/dev/null
   echo "Cleanup complete."
   exit 1
}

trap cleanup SIGINT SIGTERM

# --- Execution ---
echo "================================================"
echo "    ATAT MCSQS with Integrated Monitoring"
echo "================================================"
echo "Configuration:"
echo "  - Structure: 1_POSCAR-0.125"
echo "  - Supercell: 2×2×1 (224 atoms)"
echo "  - Parallel runs: 4"
echo "  - Command: mcsqs -rc -ip=1 & mcsqs -rc -ip=2 & ... (parallel execution)"
echo "  - Log file: $LOG_FILE"
echo "  - Progress file: $PROGRESS_FILE"
echo "================================================"

check_prerequisites

rm -f "$LOG_FILE" "$PROGRESS_FILE" mcsqs*.log

echo ""
echo "Starting ATAT MCSQS optimization and progress monitor..."

mcsqs -rc -ip=1 &
mcsqs -rc -ip=2 &
mcsqs -rc -ip=3 &
mcsqs -rc -ip=4 &
MCSQS_PID=$!

start_parallel_monitoring_process "$PROGRESS_FILE" &
MONITOR_PID=$!

echo "✅ MCSQS started"
echo "✅ Monitor started (PID: $MONITOR_PID)"
echo ""
echo "Real-time progress logged to: $PROGRESS_FILE"
echo "Press Ctrl+C to stop optimization and monitoring."
echo "================================================"

wait
MCSQS_EXIT_CODE=$?

echo ""
echo "MCSQS process finished with exit code: $MCSQS_EXIT_CODE."

echo "Allowing monitor to capture final data..."
sleep 65

kill $MONITOR_PID 2>/dev/null
wait $MONITOR_PID 2>/dev/null

echo ""
echo "================================================"
echo "              Optimization Complete"
echo "================================================"
echo "Results:"
echo "  - MCSQS log:       $LOG_FILE"
echo "  - Progress data:   $PROGRESS_FILE"
echo "  - Best structure:  bestsqs.out (if generated)"
echo "  - Correlation data: bestcorr.out (if generated)"
echo ""

if [ -f "$PROGRESS_FILE" ]; then
   echo "Progress Summary:"
   echo "  - Total monitoring time:   ~$(tail -1 "$PROGRESS_FILE" | cut -d',' -f1) minutes"
   echo "  - Best overall objective:  $(tail -1 "$PROGRESS_FILE" | cut -d',' -f$((3 + 3 * 4)))"
fi

echo "================================================"

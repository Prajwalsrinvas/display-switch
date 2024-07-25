#!/bin/bash

# Function to run basic timing test
run_timing_test() {
    echo "Running basic timing test for 60 seconds..."
    # Use 'time' command to measure execution time
    time timeout 60s ~/display_switch.sh monitor
    echo "Timing test complete."
    echo
}

# Function to run top monitoring
run_top_monitoring() {
    echo "Running top monitoring for 60 seconds..."
    # Start the display_switch.sh script in the background
    ~/display_switch.sh monitor &
    SCRIPT_PID=$!
    # Monitor the script using 'top' command
    timeout 60s top -b -n 60 -d 1 -p $SCRIPT_PID > top_output.txt
    # Kill the background process
    kill $SCRIPT_PID
    echo "Top monitoring complete. Results saved in top_output.txt"
    # Calculate and display average CPU and memory usage
    echo "Average CPU and memory usage:"
    awk '/display_switch/ {cpu_sum+=$9; mem_sum+=$10; count++} END {print "CPU: " cpu_sum/count "%, MEM: " mem_sum/count "%"}' top_output.txt
    echo
}

# Function to run perf profiling
run_perf_profiling() {
    echo "Running perf profiling for 60 seconds..."
    # Check if perf is installed
    if ! command -v perf &> /dev/null; then
        echo "perf is not installed. Please install it using: sudo apt-get install linux-tools-generic"
        return
    fi
    # Run perf stat on the display_switch.sh script
    sudo perf stat -d timeout 60s ~/display_switch.sh monitor
    echo "Perf profiling complete."
}

# Main execution
echo "Starting performance tests for display_switch.sh"
echo "================================================"

run_timing_test
run_top_monitoring
run_perf_profiling

echo "All tests completed."

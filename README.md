# Display Switch

Display Switch is a bash script that automatically manages display settings based on the power status of your laptop. It switches between laptop-only and extended display modes when the power source changes between battery and AC.


This was built out of need, as my monitor would turn off during a powercut and I had to switch displays manually or unplug the HDMI cable to view the laptop screen
.

Built with the help of `Claude 3.5 Sonnet` 🤖
## Features

- Automatically switches to laptop-only display when on battery power
- Switches to extended display mode when connected to AC power
- Logging functionality (can be enabled/disabled)
- Performance tested for efficiency

## Files

1. `display_switch.sh`: Main script for display switching
2. `test_display_switch_performance.sh`: Script for performance testing
3. `display_switch.desktop`: Desktop entry file for autostart

## Usage

### Basic Usage

```bash
./display_switch.sh {laptop|extended|monitor}
```

- `laptop`: Switch to laptop display only
- `extended`: Switch to extended display mode
- `monitor`: Start continuous monitoring of power status

<details>
  <summary>Sample log</summary>

```log
Thu Jul 25 12:07:39 PM IST 2024: Starting power monitoring
Thu Jul 25 12:07:39 PM IST 2024: System is on AC power
Thu Jul 25 12:07:39 PM IST 2024: Power state changed from  to ac
Thu Jul 25 12:07:39 PM IST 2024: Switching to extended display
Thu Jul 25 12:07:39 PM IST 2024: Switch to extended display completed
Thu Jul 25 12:07:44 PM IST 2024: System is on AC power
Thu Jul 25 12:07:49 PM IST 2024: System is on AC power
Thu Jul 25 12:07:54 PM IST 2024: System is on AC power
Thu Jul 25 12:07:59 PM IST 2024: System is on battery
Thu Jul 25 12:07:59 PM IST 2024: Power state changed from ac to battery
Thu Jul 25 12:07:59 PM IST 2024: Switching to laptop display only
Thu Jul 25 12:08:00 PM IST 2024: Switch to laptop display completed
Thu Jul 25 12:08:05 PM IST 2024: System is on battery
Thu Jul 25 12:08:10 PM IST 2024: System is on battery
Thu Jul 25 12:08:15 PM IST 2024: System is on AC power
Thu Jul 25 12:08:15 PM IST 2024: Power state changed from battery to ac
Thu Jul 25 12:08:15 PM IST 2024: Switching to extended display
Thu Jul 25 12:08:17 PM IST 2024: Switch to extended display completed
Thu Jul 25 12:08:22 PM IST 2024: System is on AC power
Thu Jul 25 12:08:27 PM IST 2024: System is on AC power
Thu Jul 25 12:08:32 PM IST 2024: System is on AC power
```
</details>

### Enabling Autostart

1. Copy `display_switch.desktop` to `~/.config/autostart/`
2. Ensure the `Exec` path in the `.desktop` file points to your `display_switch.sh` location

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/prajwalsrinvas/display-switch.git
   ```
2. Make the scripts executable:
   ```bash
   chmod +x display_switch.sh test_display_switch_performance.sh
   ```
3. (Optional) Copy `display_switch.desktop` to autostart:
   ```bash
   cp display_switch.desktop ~/.config/autostart/
   ```

## Configuration

To enable or disable logging, use the `--log` flag:

```bash
./display_switch.sh monitor --log
```

## Managing the Display Switch Process

### Checking if Display Switch is Running

To check if the Display Switch script is currently running, use the following command:

```bash
pgrep -f "display_switch.sh monitor"
```

If this command returns a process ID, the script is running. If it doesn't return anything, the script is not currently active.

### Stopping the Display Switch Process

To stop the Display Switch script if it's currently running:

1. Find the process ID:
   ```bash
   pgrep -f "display_switch.sh monitor"
   ```
2. Kill the process using the ID from the previous step:
   ```bash
   kill $(pgrep -f "display_switch.sh monitor")
   ```

Alternatively, you can use a single command to find and kill the process:

```bash
pkill -f "display_switch.sh monitor"
```

### Disabling Autostart

To prevent Display Switch from starting automatically on boot:

1. Remove or rename the `.desktop` file in the autostart directory:
   ```bash
   rm ~/.config/autostart/display_switch.desktop
   ```
   or
   ```bash
   mv ~/.config/autostart/display_switch.desktop ~/.config/autostart/display_switch.desktop.disabled
   ```

2. The change will take effect on the next login or reboot.

To re-enable autostart, simply copy the `display_switch.desktop` file back to the `~/.config/autostart/` directory.

## Performance Test Results

The `test_display_switch_performance.sh` script runs three types of tests:

1. Basic timing test
2. Top monitoring
3. Perf profiling

### Results Analysis

<details>
  <summary>Test perf script output</summary>
  ```
  Starting performance tests for display_switch.sh
================================================
Running basic timing test for 60 seconds...
real    1m0.002s
user    0m0.013s
sys    0m0.040s
Timing test complete.
Running top monitoring for 60 seconds...
Top monitoring complete. Results saved in top_output.txt
Average CPU and memory usage:
CPU: 0%, MEM: 0%
Running perf profiling for 60 seconds...
 Performance counter stats for 'timeout 60s /home/prajwal/display_switch.sh monitor':
             55.62 msec task-clock                       #    0.001 CPUs utilized             
               273      context-switches                 #    4.908 K/sec                     
                28      cpu-migrations                   #  503.427 /sec                      
             4,040      page-faults                      #   72.637 K/sec                     
       122,667,616      cycles                           #    2.206 GHz                       
        86,842,966      instructions                     #    0.71  insn per cycle            
        15,647,264      branches                         #  281.331 M/sec                     
           468,483      branch-misses                    #    2.99% of all branches           
                        TopdownL1                 #     20.9 %  tma_backend_bound      
                                                  #     13.0 %  tma_bad_speculation    
                                                  #     46.8 %  tma_frontend_bound     
                                                  #     19.3 %  tma_retiring           
        20,625,569      L1-dcache-loads                  #  370.838 M/sec                     
         1,237,187      L1-dcache-load-misses            #    6.00% of all L1-dcache accesses 
           226,473      LLC-loads                        #    4.072 M/sec                     
           134,100      LLC-load-misses                  #   59.21% of all LL-cache accesses  
      60.001753561 seconds time elapsed
       0.010354000 seconds user
       0.046153000 seconds sys
Perf profiling complete.
All tests completed.
  ```
</details>

1. Basic timing test:
   - Real time: 1m0.002s (as expected, it ran for 60 seconds)
   - User time: 0.013s
   - System time: 0.040s

   This shows very low CPU usage, with only about 0.053 seconds of CPU time used over a 60-second period.

2. Top monitoring:
   - Average CPU usage: 0%
   - Average memory usage: 0%

   These results indicate that the script has a negligible impact on both CPU and memory.

3. Perf profiling:
   - Task-clock: 55.62 msec (0.001 CPUs utilized)
   - Context-switches: 273 (4.908 K/sec)
   - CPU-migrations: 28 (503.427 /sec)
   - Page-faults: 4,040 (72.637 K/sec)
   - Cycles: 122,667,616
   - Instructions: 86,842,966 (0.71 insn per cycle)

   The perf results confirm the minimal resource usage:
   - Only 0.001 CPUs utilized on average
   - Low number of context switches and CPU migrations
   - Reasonable instruction per cycle rate

Based on these results, we can conclude:

1. The script has an extremely low impact on system resources.
2. CPU usage is negligible, barely registering on the measurements.
3. Memory usage is also negligible.
4. The 5-second interval for checking power status is not causing any noticeable performance issues.

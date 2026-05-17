function fixConserve
# The kernel path for the ideapad battery module
    set -l sys_path "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

    # Check if the laptop actually supports this interface
    if not test -f $sys_path
        echo "Error: Conservation mode interface not found."
        echo "Ensure you are on a Lenovo IdeaPad and the ideapad_laptop module is loaded."
        return 1
    end

    switch "$argv[1]"
        case "full"
            # Disables conservation mode (charges to 100%)
            echo 0 | sudo tee $sys_path > /dev/null
            echo "🔋 Charging mode set to FULL (Will charge to 100%)"
            
        case "conserve"
            # Enables conservation mode (caps at 60%)
            echo 1 | sudo tee $sys_path > /dev/null
            echo "🔌 Charging mode set to CONSERVE (Capped at 60%)"
            
        case "status"
            # Checks the current state
            set -l state (cat $sys_path)
            if test "$state" = "1"
                echo "Current Status: CONSERVE (Capped at 60%)"
            else
                echo "Current Status: FULL (Charges to 100%)"
            end
            
        case "*"
            # Help text if no valid argument is passed
            echo "Usage: lenovo_battery [full | conserve | status]"
    end
end

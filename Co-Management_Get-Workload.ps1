Function Get-Workload { 

    [CmdletBinding()] 

    Param( 

        [Parameter(Position = 0, Mandatory = $true)] 

        [ValidateRange(1,12543)] 

        [Int32[]]$capability 

    ) 

  

    #Create enumurator for workload flags // ConfigMgr 2111+ 

    [flags()] Enum workloads { 

        CoMgmt_Enabled = 8193 

        Compliance_Policies = 2 

        Resource_Access_Policies = 4 

        Device_Configuration = 8 

        Windows_Update_Policies = 16 

        Client_Apps = 64 

        Office_Click2Run_Apps = 128 

        Endpoint_Protection = 4128 

    } 

  

    #Create an ordered hash table to capture all capabilities 

    $allCapabilities = [Ordered]@{} 

  

    ForEach ($capNum in $capability) { 

  

        #Evaluate capabilities  

        If ($capNum -eq 1) { 

            $capResult = @("CoMgmt_Disabled") 

  

            #Build hash table of results 

            $allCapabilities.Add([string]$capNum, $capResult) 

        } 

        elseIf ($capNum -eq 8193) { 

            $capResult = @("CoMgmt_Enabled_NoWorkloads") 

  

            #Build hash table of results 

            $allCapabilities.Add([string]$capNum, $capResult) 

        } 

        elseIf ($capNum -lt 8193) { 

            $capResult = @("Invalid_Workload_Value") 

  

            #Build hash table of results 

            $allCapabilities.Add([string]$capNum, $capResult) 

        } 

        else { 

            Try { 

                $workload = [workloads]$capNum 

  

                #Build data if a valid flag is matched 

                If ($workload -like "*_*") { 

               

                    #Filter out CoMgmt_Enabled value - we assume it is enabled if we have a workload match 

                    $capabilities = $workload -split ', ' -notmatch 'CoMgmt_Enabled' 

  

                    #Tidy up and export capabilities sorted to an array 

                    $capabilities = $capabilities | Sort-Object 

                    $capResult = @($capabilities) 

  

                    #Build hash table of results 

                    $allCapabilities.Add([string]$capNum, $capResult) 

                } 

            } 

            Catch { 

                #Do Nothing, ignore invalid values 

            } 

        } 

    } 

    Return $allCapabilities 

} 
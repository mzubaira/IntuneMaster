Function Get-AllWorkloads {
    
    #Create enumurator for workload flags // ConfigMgr 2111+
    [flags()] Enum allWorkloads {
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

    8195..12543 | Foreach-Object {

        $capNum = [string]$_

        #Evaluate capabilities s
        Try {
            $workload = [allWorkloads]$capNum

            #Build data if a valid flag is matched
            If ($workload -like "*_*") {
              
                #Filter out CoMgmt_Enabled value - we assume it is enabled if we have a workload match
                $capabilities = $workload -split ', ' -notmatch 'CoMgmt_Enabled'

                #Tidy up and export capabilities sorted to an array
                $capabilities = $capabilities | Sort-Object
                $capResult = @($capabilities)

                #Build hash table of results
                $allCapabilities.Add($capNum, $capResult)
            }
        }
        Catch {
            #Do Nothing, ignore invalid values
        }
    }
    Return $allCapabilities
}
#process the Account Management menu, each switch option calls function
while ($choice -ne 0){
    get-exchangeserver #Display the menu options function

    $choice = read-host "Selection"
    switch ($choice)
        {
            0 {break} #Return to main menu
            1 {get-mailbox michael.tompkins}
            2 {}
            3 {}
            4 {}
            default {write-host "Please choose a selection." -foregroundcolor red}
        }
}
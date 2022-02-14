using namespace System.Management.Automation.Host

$networkCardModel = [ChoiceDescription]::new('&Card info', 'Show network card model')
$blue = [ChoiceDescription]::new('&Blue', 'Favorite color: Blue')
$yellow = [ChoiceDescription]::new('&Yellow', 'Favorite color: Yellow')

$options = [ChoiceDescription[]]($networkCardModel, $blue, $yellow)

$result = $host.ui.PromptForChoice($Title, $Question, $options, 0)
using Godot;

public partial class RescuedPrompt : Window
{
    private Label promptLabel;
    private Button closeButton;

	[Signal]
    public delegate void AnimalRescuedEventHandler();

    public override void _Ready()
    {
        // getting child node
        promptLabel = GetNode<Label>("VBoxContainer/Label");
        closeButton = GetNode<Button>("VBoxContainer/Button");

        // setting prompt
        // promptLabel.Text = "You rescued a creature!";

        // close the prompt when pressed
        closeButton.Pressed += OnCloseButtonPressed;
		// EmitSignal("AnimalRescued");
        // hide the prompt
        Hide();
    }


	    private void OnCloseButtonPressed()
    {
        // emit AnimalRescued singnal
        // EmitSignal("AnimalRescued");
		EmitSignal(SignalName.AnimalRescued);
        GD.Print("Animal rescued signal emitted!");

        // hide prompt
        Hide();
    }

    // show prompt
    public void ShowPrompt()
    {
        Show();
    }
}

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
		Hide();
	}

// when close the prompt call AnimalRescued

		private async void OnCloseButtonPressed()
	{

		Hide();
		EmitSignal("AnimalRescued");
		await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
		GD.Print("Waited 1 second after rescue");

	}
		
	// show prompt
	public void ShowPrompt()
	{
		Show();
	}
}

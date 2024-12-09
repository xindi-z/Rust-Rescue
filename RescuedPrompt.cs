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

// when close the prompt call rescueTriggered


		private void OnCloseButtonPressed()
	{
		var inv_ui_GDScript = GD.Load<GDScript>("res://inventory/inv_ui.gd");
		var inv_ui_Node = (GodotObject)inv_ui_GDScript.New(); // This is a GodotObject.

		var inv_GDScript = GD.Load<GDScript>("res://inventory/inventory.gd");
		var inv_Instance  = (GodotObject)inv_GDScript.New(); // This is a GodotObject.
		
		var item = GD.Load<GodotObject>("res://inventory/creatures/bunny_resized.tres");


		
    	inv_ui_Node.Set("inv", inv_Instance);
		inv_ui_Node.Set("InvItem", item);
		inv_ui_Node.Call("collect", item);



		// emit AnimalRescued singnal
		// EmitSignal("AnimalRescued");
		EmitSignal(SignalName.AnimalRescued);
		GD.Print("Animal rescued signal emitted!");



		// hide prompt
		Hide();
	}
		//  here is where i should add inventory gets trigger
		// and storeline
		
	// show prompt
	public void ShowPrompt()
	{
		Show();
	}
}

using Godot;
using System;
using System.IO.Ports;

public partial class rescue : Node2D
{


	private SerialPort serialPort;
	private RichTextLabel text;
	private RescuedPrompt rescuedlPrompt;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
			text = GetNode<RichTextLabel>("RichTextLabel");
			rescuedlPrompt = GetNode<RescuedPrompt>("RescuedPrompt");
			serialPort = new SerialPort();
			serialPort.PortName = "COM3";
			serialPort.BaudRate = 9600;
			// serialPort.Open();  
			try
			{
				if (!serialPort.IsOpen)
				{
					serialPort.Open();
					GD.Print("Port successfully opened");
				}
			}
			catch (Exception ex)
			{
				GD.PrintErr("Failed to open port: ", ex.Message);
			}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override async void _Process(double delta)
	{
		if(!serialPort.IsOpen){
			GD.Print("port is closed");
			return;
		}
		string serialMessage = serialPort.ReadExisting();		//print out arduino print


		if(serialMessage == "a\r\n"){
			// text.Text = "You rescued a creature!";
			GD.Print("Animal rescued");
			 rescuedlPrompt.ShowPrompt();
		}

	}
	
		public override void _ExitTree()
	{
		// close port
		if (serialPort.IsOpen)
		{
			serialPort.Close();
		}
	}

}

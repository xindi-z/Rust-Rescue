//using Godot;
//using System;
//using System.IO.Ports;
//
//public partial class rescue : Node2D
//{
//
//
	//private SerialPort serialPort;
	//private RichTextLabel text;
	//private RescuedPrompt rescuedlPrompt;
	//
	//// Called when the node enters the scene tree for the first time.
	//public override void _Ready()
	//{
			//text = GetNode<RichTextLabel>("RichTextLabel");
			//rescuedlPrompt = GetNode<RescuedPrompt>("RescuedPrompt");
			//serialPort = new SerialPort();
			//serialPort.PortName = "COM3";
			//serialPort.BaudRate = 9600;
			//// serialPort.Open();  
			//try
			//{
				//if (!serialPort.IsOpen)
				//{
					//serialPort.Open();
					//GD.Print("Port successfully opened");
				//}
			//}
			//catch (Exception ex)
			//{
				//GD.PrintErr("Failed to open port: ", ex.Message);
			//}
	//}
//
	//// Called every frame. 'delta' is the elapsed time since the previous frame.
	//public override async void _Process(double delta)
	//{
		//if(!serialPort.IsOpen){
			//GD.Print("port is closed");
			//return;
		//}
		//string serialMessage = serialPort.ReadExisting();		//print out arduino print
//
//
		//if(serialMessage == "a\r\n"){
			//// text.Text = "You rescued a creature!";
			//GD.Print("Animal rescued");
			 //rescuedlPrompt.ShowPrompt();
		//}
//
	//}
	//
		//public override void _ExitTree()
	//{
		//// close port
		//if (serialPort.IsOpen)
		//{
			//serialPort.Close();
		//}
	//}
//
//}

////第二版
//using Godot;
//using System;
//
//public partial class rescue : Node2D
//{
	//private GodotObject blePlugin;
	//private RichTextLabel text;
	//private RescuedPrompt rescuedlPrompt;
//
	//private string targetDeviceName = "ForceSensorESP32";  // 你的 ESP32 设备名
	//private string connectedDevice = "";
	//
	//// 这里要和 ESP32 代码中的 UUID 保持一致
	//private string serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
	//private string characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
//
	//public override void _Ready()
	//{
		//text = GetNode<RichTextLabel>("RichTextLabel");
		//rescuedlPrompt = GetNode<RescuedPrompt>("RescuedPrompt");
//
		//// 获取 BLEPlugin 实例
		//if (Engine.HasSingleton("BLEPlugin"))
		//{
			//blePlugin = Engine.GetSingleton("BLEPlugin");
			//blePlugin.Call("initialize");
			//GD.Print("BLE Plugin 已初始化");
//
			//// 监听 BLE 设备扫描
			//blePlugin.Connect("device_found", new Callable(this, nameof(_OnDeviceFound)));
//
			//// 开始扫描 BLE 设备
			//var scan_filter = new Godot.Collections.Dictionary();
			//scan_filter["name"] = "ForceSensorESP32"; // 仅扫描目标设备
			////blePlugin.Call("start_scan", scan_filter);
			//GD.Print("开始扫描 BLE 设备...");
		//}
		//else
		//{
			//GD.PrintErr(" BLE Plugin 未找到！");
		//}
	//}
//
	//// 当发现 BLE 设备时触发
	//private void _OnDeviceFound(string deviceName, string deviceAddress)
	//{
		//GD.Print($"发现设备: {deviceName} 地址: {deviceAddress}");
//
		//if (deviceName == targetDeviceName)
		//{
			//GD.Print($" 发现目标设备 {targetDeviceName}，正在连接...");
			//blePlugin.Call("stop_scan");
			//connectedDevice = deviceAddress;
//
			//// 连接设备
			//blePlugin.Call("connect_device", connectedDevice);
			//blePlugin.Connect("device_connected", new Callable(this, nameof(_OnDeviceConnected)));
//
		//}
	//}
//
	//// 设备连接成功后触发
	//private void _OnDeviceConnected()
	//{
		//GD.Print(" 成功连接到 ESP32 设备！");
//
		//// 订阅压力传感器数据
		//blePlugin.Call("enable_notifications", connectedDevice, serviceUUID, characteristicUUID);
		//
		//// 监听 BLE 传感器数据
		//blePlugin.Connect("characteristic_changed", new Callable(this, nameof(_OnDataReceived)));
//
	//}
//
	//// 处理 ESP32 发送的压力数据
	//private void _OnDataReceived(string deviceAddress, string characteristic, string value)
	//{
		//GD.Print($" 接收到 BLE 数据: {value}");
//
		//// 解析数据
		//if (int.TryParse(value, out int pressureValue))
		//{
			//GD.Print($" 压力传感器数据: {pressureValue}");
//
			//// 如果压力超过阈值，则触发救援功能
			//if (pressureValue > 50) 
			//{
				//TriggerRescue();
			//}
		//}
		//else
		//{
			//GD.PrintErr("解析压力数据失败！");
		//}
	//}
//
	//// 触发游戏内的救援逻辑
	//private void TriggerRescue()
	//{
		//GD.Print(" 压力传感器触发救援！");
		//rescuedlPrompt.ShowPrompt();
	//}
//}
//第三版
using Godot;
using System;

public partial class rescue : Node2D
{
	private GodotObject blePlugin;
	private RichTextLabel text;
	private RescuedPrompt rescuedlPrompt;

	private string targetDeviceName = "ForceSensorESP32";  // 你的 ESP32 设备名
	private string connectedDevice = "";
	
	// 这里要和 ESP32 代码中的 UUID 保持一致
	private string serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
	private string characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

	public override void _Ready()
	{

	}


	private void TriggerRescue()
	{
		GD.Print("🚀 压力传感器触发救援！");
		rescuedlPrompt.ShowPrompt();
	}
}

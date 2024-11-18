using Godot;

public partial class RescuedPrompt : Window
{
    private Label promptLabel;
    private Button closeButton;

	[Signal]
    public delegate void AnimalRescuedEventHandler();

    public override void _Ready()
    {
        // 获取子节点
        promptLabel = GetNode<Label>("VBoxContainer/Label");
        closeButton = GetNode<Button>("VBoxContainer/Button");

        // 设置提示文本
        // promptLabel.Text = "You rescued a creature!";

        // 按钮点击时关闭提示框
        closeButton.Pressed += OnCloseButtonPressed;
		// EmitSignal("AnimalRescued");
        // 默认隐藏提示框
        Hide();
    }


	    private void OnCloseButtonPressed()
    {
        // 发射 AnimalRescued 信号
        // EmitSignal("AnimalRescued");
		EmitSignal(SignalName.AnimalRescued);
        GD.Print("Animal rescued signal emitted!");

        // 隐藏提示框
        Hide();
    }

    // 显示提示框的方法
    public void ShowPrompt()
    {
        Show();
    }
}

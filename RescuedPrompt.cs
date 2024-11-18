using Godot;

public partial class RescuedPrompt : Window
{
    private Label promptLabel;
    private Button closeButton;

    public override void _Ready()
    {
        // 获取子节点
        promptLabel = GetNode<Label>("VBoxContainer/Label");
        closeButton = GetNode<Button>("VBoxContainer/Button");

        // 设置提示文本
        // promptLabel.Text = "You rescued a creature!";

        // 按钮点击时关闭提示框
        closeButton.Pressed += () => Hide();

        // 默认隐藏提示框
        Hide();
    }

    // 显示提示框的方法
    public void ShowPrompt()
    {
        Show();
    }
}

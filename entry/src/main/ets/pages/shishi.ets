@Entry
@Component
struct Home {
  build() {
    // 外层 Column：让整个内容区域在页面中水平居中
    Column() {
      Column() {
        Text('需要居中的内容')
          .width('60%')
          .height(50)
          .backgroundColor(Color.Orange)
      }
      .width('80%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#F5F5F5')
      .height(100) // 可根据需求设置高度
    }
    .width('100%') // 外层 Column 占满页面宽度
    .justifyContent(FlexAlign.Center) // 外层 Column 垂直居中（可选，让内容在页面垂直方向也居中）
    .alignItems(HorizontalAlign.Center); // 外层 Column 水平居中，让内部 Column 整体居中
  }
}
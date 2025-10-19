import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct FeedbackPage {
  // @Prop 必须定义在组件顶层，不能放在 build 方法内
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");

  // 反馈内容状态管理
  @State feedbackContent: string = '';
  @State errorMessage: string = '';

  // 提交反馈
  private submitFeedback() {
    // 简单验证
    if (!this.feedbackContent.trim()) {
      this.errorMessage = '请输入反馈内容';
      return;
    }

    if (this.feedbackContent.length < 5) {
      this.errorMessage = '反馈内容不能少于5个字符';
      return;
    }

    // 模拟提交成功
    this.errorMessage = '';
    promptAction.showToast({
      message: '反馈提交成功，感谢您的建议！',
      duration: 2000
    });

    // 返回设置页
    setTimeout(() => {
      router.pushUrl({ url: 'pages/Teasetting' });
    }, 1000);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 8 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Teasetting' });
          });

        Text('反馈')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontWeight(FontWeight.Medium);

        Column() {}
        .width(24)
        .height(24)
        .margin({ right: 8 });
      }
      .width('100%')
      .height(65)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .shadow({ radius: 2, color: '#00000010' });

      // 反馈内容输入区域
      Column() {
        Text('请输入您的反馈或建议')
          .fontSize(14)
          .margin({ bottom: 10, left: 2, top: 20 })
          .alignSelf(ItemAlign.Start);

        TextArea({ placeholder: '请详细描述您遇到的问题或建议...' })
          .width('100%')
          .height(200)
          .backgroundColor('#ffffff')
          .borderRadius(8)
          .padding(12)
          .maxLength(500) // 限制最大输入长度
          .onChange((value: string) => {
            this.feedbackContent = value;
          });

        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#ff3b30')
            .margin({ top: 10, bottom: 10 })
            .alignSelf(ItemAlign.Start);
        }

        // 字符计数提示
        Text(`${this.feedbackContent.length}/500`)
          .fontSize(12)
          .fontColor('#888888')
          .margin({ bottom: 20 })
          .alignSelf(ItemAlign.End);

        // 提交按钮
        Button('提交反馈')
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#ff77f0ec')
          .borderRadius(8)
          .onClick(() => this.submitFeedback());

      }
      .width('90%')
      .flexGrow(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}

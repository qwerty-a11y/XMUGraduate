import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct ChangeContactInformation {
  // 联系信息状态管理
  @State phoneNumber: string = '';
  @State email: string = '';
  @State verificationCode: string = '';
  // 验证码相关状态
  @State codeButtonText: string = '获取验证码';
  @State isCodeButtonDisabled: boolean = false;
  @State countdown: number = 60;
  // 错误提示信息
  @State errorMessage: string = '';

  // 返回图标资源
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");

  // 获取验证码
  private getVerificationCode() {
    // 验证邮箱格式
    if (!this.email) {
      this.errorMessage = '请先输入邮箱地址';
      return;
    }

    const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailReg.test(this.email)) {
      this.errorMessage = '请输入有效的邮箱地址';
      return;
    }

    // 模拟发送验证码
    this.errorMessage = '';
    this.isCodeButtonDisabled = true;
    this.countdown = 60;

    // 显示提示
    promptAction.showToast({
      message: '验证码已发送至您的邮箱',
      duration: 2000
    });

    // 倒计时逻辑
    const timer = setInterval(() => {
      this.countdown--;
      this.codeButtonText = `${this.countdown}s后重新获取`;

      if (this.countdown <= 0) {
        clearInterval(timer);
        this.codeButtonText = '获取验证码';
        this.isCodeButtonDisabled = false;
      }
    }, 1000);

    // 实际项目中这里应该调用后端接口发送验证码
  }

  // 验证联系信息并提交
  private submitContactChange() {
    // 验证手机号
    if (!this.phoneNumber) {
      this.errorMessage = '请输入手机号';
      return;
    }

    const phoneReg = /^1[3-9]\d{9}$/;
    if (!phoneReg.test(this.phoneNumber)) {
      this.errorMessage = '请输入有效的手机号';
      return;
    }

    // 验证邮箱（如果填写）
    if (this.email) {
      const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailReg.test(this.email)) {
        this.errorMessage = '请输入有效的邮箱地址';
        return;
      }

      // 验证验证码
      if (!this.verificationCode) {
        this.errorMessage = '请输入验证码';
        return;
      }

      // 简单验证验证码长度（实际项目中应与后端校验）
      if (this.verificationCode.length !== 6) {
        this.errorMessage = '验证码格式不正确';
        return;
      }
    }

    // 验证通过，模拟修改成功
    this.errorMessage = '';

    promptAction.showToast({
      message: '联系方式修改成功',
      duration: 2000
    });

    // 返回设置页
    setTimeout(() => {
      router.pushUrl({ url: 'pages/setting' });
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
            router.pushUrl({ url: 'pages/Setting' });
          });

        Text('修改联系方式')
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

      // 输入区域
      Column() {
        // 手机号输入框
        Column() {
          Text('手机号')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          TextInput({ placeholder: '请输入手机号' })
            .type(InputType.Number)
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .maxLength(11)
            .onChange((value: string) => {
              this.phoneNumber = value;
            });
        }
        .margin({ bottom: 15 });

        // 邮箱输入框
        Column() {
          Text('邮箱')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          TextInput({ placeholder: '请输入邮箱地址' })
            .type(InputType.Email)
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.email = value;
            });
        }
        .margin({ bottom: 15 });

        // 验证码输入框 + 获取按钮
        Column() {
          Text('验证码')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          Row() {
            TextInput({ placeholder: '请输入6位验证码' })
              .type(InputType.Number)
              .flexGrow(1)
              .height(48)
              .width('60%')
              .backgroundColor('#ffffff')
              .borderRadius(8)
              .padding({ left: 12 })
              .maxLength(6)
              .onChange((value: string) => {
                this.verificationCode = value;
              });

            Button(this.codeButtonText)

              .width(120)
              .height(48)
              .fontSize(14)
              .margin({ left: 10 })
              .backgroundColor(this.isCodeButtonDisabled ? '#cccccc' : '#ff77f0ec')
              .borderRadius(8)
              .enabled(!this.isCodeButtonDisabled)  // enabled为false时按钮禁用
              .onClick(() => this.getVerificationCode());
          }
        }
        .margin({ bottom: 15 });

        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#ff3b30')
            .margin({ bottom: 20 })
            .alignSelf(ItemAlign.Start);
        }

        // 提交按钮
        Button('确认修改')
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#ff77f0ec')
          .borderRadius(8)
          .onClick(() => this.submitContactChange())
          .margin({ top: 10 });

      }
      .width('90%')
      .padding({ top: 30 })
      .flexGrow(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}

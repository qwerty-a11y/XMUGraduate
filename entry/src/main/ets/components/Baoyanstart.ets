@Component
export struct Baoyanstartbg {
  // 背景图资源
  private bgImage: ResourceStr = $r('app.media.baoyan_bg');

  build() {
    Image(this.bgImage)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover); // 让背景图覆盖整个区域
  }
}

@Component
export struct Baoyanlogo {
  // 图标资源
  private logoImage: ResourceStr = $r('app.media.baoyan_logo');

  build() {
    Image(this.logoImage)
      .width('100%') // 使用百分比适应父容器大小
      .height('100%')
      .objectFit(ImageFit.Contain)
  }
}

// Baoyanlogin.ets
// @Component
// export struct Baoyanlogin {
//   @State selectedValue: string = 'student';
//   build() {
//     Column() {
//       // 身份选择
//       Row() {
//         // 学生选项（将Radio与Text合并为一个整体）
//         Row() {
//           Radio({ value: 'student', group: 'identity' })
//             .checked(this.selectedValue === 'student')
//             .onChange((isChecked: boolean) => {
//               if (isChecked) this.selectedValue = 'student';
//             })
//             .width(0).height(0) // 隐藏Radio
//             .position({ x: -100, y: 0 }); // 绝对定位到可视区域外，彻底不影响布局
//           Text('学生')
//             .fontSize(16)
//             .fontWeight(FontWeight.Medium)
//             .padding({ top: 12, bottom: 12 })
//             .backgroundColor(this.selectedValue === 'student' ? '#AFEEEE' : '#FFFFFF')
//             .borderRadius(20)
//             .flexGrow(1)
//             .textAlign(TextAlign.Center)
//             .onClick(() => this.selectedValue = 'student');
//         }
//         .flexGrow(1) // 占1/3宽度
//
//         // 教师选项
//         Row() {
//           Radio({ value: 'teacher', group: 'identity' })
//             .checked(this.selectedValue === 'teacher')
//             .onChange((isChecked: boolean) => {
//               if (isChecked) this.selectedValue = 'teacher';
//             })
//             .width(0).height(0)
//             .position({ x: -100, y: 0 }); // 移出可视区域
//           Text('教师')
//             .fontSize(16)
//             .fontWeight(FontWeight.Medium)
//             .padding({ top: 12, bottom: 12 })
//             .backgroundColor(this.selectedValue === 'teacher' ? '#AFEEEE' : '#FFFFFF')
//             .borderRadius(20)
//             .flexGrow(1)
//             .textAlign(TextAlign.Center)
//             .onClick(() => this.selectedValue = 'teacher');
//         }
//         .flexGrow(1) // 占1/3宽度
//
//         // 超管选项
//         Row() {
//           Radio({ value: 'super', group: 'identity' })
//             .checked(this.selectedValue === 'super')
//             .onChange((isChecked: boolean) => {
//               if (isChecked) this.selectedValue = 'super';
//             })
//             .width(0).height(0)
//             .position({ x: -100, y: 0 }); // 移出可视区域
//           Text('超管')
//             .fontSize(16)
//             .fontWeight(FontWeight.Medium)
//             .padding({ top: 12, bottom: 12 })
//             .backgroundColor(this.selectedValue === 'super' ? '#AFEEEE' : '#FFFFFF')
//             .borderRadius(20)
//             .flexGrow(1)
//             .textAlign(TextAlign.Center)
//             .onClick(() => this.selectedValue = 'super');
//         }
//         .flexGrow(1) // 占1/3宽度
//       }
//       .alignItems(VerticalAlign.Center)
//       .width('100%')
//       .margin({ bottom: 15 })
//       .borderRadius(20)
//       .backgroundColor('#FFFFFF');
//
//
//
//
//       // 账号输入框
//       TextInput({ placeholder: '输入账号' })
//         .width('100%')
//         .height(40)
//         .backgroundColor('#FFFFFF')
//         .borderRadius(8)
//         .shadow({
//           color: '#12000000', // 半透明黑色（最后两位是透明度，00-FF）
//           radius: 4, // 阴影模糊程度（数值越大越模糊）
//           offsetX: 2, // 水平方向偏移（正数右移，负数左移）
//           offsetY: 4          // 垂直方向偏移（正数下移，负数上移）
//         })
//         .margin({ bottom: 15 });
//
//
//       // 密码输入框
//       TextInput({ placeholder: '输入密码' })
//         .type(InputType.Password)
//         .width('100%')
//         .height(40)
//         .backgroundColor('#FFFFFF')
//         .borderRadius(8)
//         .shadow({
//           color: '#12000000', // 半透明黑色（最后两位是透明度，00-FF）
//           radius: 4, // 阴影模糊程度（数值越大越模糊）
//           offsetX: 2, // 水平方向偏移（正数右移，负数左移）
//           offsetY: 4          // 垂直方向偏移（正数下移，负数上移）
//         })
//         .margin({ bottom: 15 })
//
//
//       // 忘记密码
//       Text('忘记密码？')
//         .fontSize(12)
//         .fontColor('#FF0000')
//         .margin({ bottom: 15 })
//         .align(Alignment.Start)
//         .width('100%');
//
//       // 登录按钮
//       Button('登录')
//         .width('80%')
//         .height(45)
//         .backgroundColor('#ff77f0ec')
//         .borderRadius(16);
//     }
//     .width('100%')
//     .height('100%')
//     //.backgroundColor('#FFFFFF') // 这里可以根据需要设置背景，也可以结合之前的背景图组件
//     .margin({ bottom: '0' })
//   }
//}
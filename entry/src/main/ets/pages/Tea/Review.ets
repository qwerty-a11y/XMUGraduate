import router from '@ohos.router';

@Entry
@Component
struct ScoreApplyReviewPage {
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  build() {
    Column({ space: 16 }) {
      // 头部标题栏
      Row({ space: 10 }) {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Tea/Main' });
          });
        Text("审核")
          .fontSize(16)
          .fontWeight(500)
          .width('50%')
          .margin({ right: 16 });
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

      // 修复Scroll子组件问题：用一个Column包裹所有内容
      Scroll() {
        Column({ space: 16 }) { // 新增外层Column，作为Scroll的唯一子组件
          // 类型
          Text("类型")
            .fontSize(14)
            .width('90%')
            .fontColor('#666666')
            .margin({ left: 16 });
          Text("学术竞赛")
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .height(36)
            .textAlign(TextAlign.Center)
            .borderRadius(8);

          // 名称
          Text("名称")
            .fontSize(14)
            .fontColor('#666666')
            .width('90%')
            .margin({ left: 16 });
          Text("全国大学生数学竞赛")
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .height(36)
            .textAlign(TextAlign.Center)
            .borderRadius(8);

          // 详细描述
          Text("详细描述")
            .fontSize(14)
            .width('90%')
            .fontColor('#666666')
            .margin({ left: 16 });
          Text("决赛一等奖")
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')

            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12 ,bottom:12});

          // 申请分值
          Row({ space: 10 }) {
            Text("申请分值")
              .fontSize(14)
              .width('60%')
              .fontColor('#666666')
              .margin({ left: 20 });
            Text("2")
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
              .margin({ right: 16 });
          }
          .width('100%')
          .alignItems(VerticalAlign.Center);

          // 证明文件
          Text("证明文件")
            .fontSize(14)
            .width('90%')
            .fontColor('#666666')
            .margin({ left: 16 });
          Column({ space: 10 }) {
            Image(this.image_world)
              .width(24)
              .height(24)
              .margin({ left: 16, top: 10 });
            Text("点击下载证明文件")
              .fontSize(14)
              .width('50%')
              .height(10)
              .margin({ bottom: 10 })
              .textAlign(TextAlign.Center)
          }
          .backgroundColor('#e9e9e9')
          .borderRadius(8)
          .width('90%')
          .alignItems(HorizontalAlign.Center);

          // 给分
          Row({ space: 10 }) {
            Text("给分：")
              .fontSize(14)
              .width('60%')
              .fontColor('#333333')
              .margin({ left: 20 });
            Text("2")
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8);
          }
          .width('100%')
          .alignItems(VerticalAlign.Center);

          // 反馈
          Text("反馈 (给分不等于申请分值或不通过时写)")
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 16 });
          Text("没有盖章")
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .height(80)
            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12 });

          // 操作按钮
          Row({ space: 20 }) {
            Button("不通过")
              .fontSize(14)
              .fontWeight(500)
              .width(120)
              .height(44)
              .backgroundColor('#66ccff')
              .borderRadius(8);
            Button("通过")
              .fontSize(14)
              .fontWeight(500)
              .width(120)
              .height(44)
              .backgroundColor('#66ff99')
              .borderRadius(8);
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 20, bottom: 30 });
        }
        .width('100%') // 确保内部Column占满宽度
      }
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .padding({ top: 16 });
  }
}
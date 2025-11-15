import router from '@ohos.router';
import { RecordEntry } from '../../datatypes/Record';

@Entry
@Component
struct ScoreApplyReviewPage {
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']
  private statusList:string[] = ['草稿','审核中','审核通过','审核失败']
  @State data?:RecordEntry=undefined;

  aboutToAppear(): void {
    this.data = router.getParams() as RecordEntry
  }

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
          Text(this.typeList[this.data!.ReviewStatus.valueOf()])
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
          Text(this.data!.Title)
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
          Text(this.data!.Description)
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
            Text(this.data!.ApplyScore.toString())
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
            TextInput()
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
              .onChange((text)=>{
                this.data!.RealScore = Number(text)
              });
          }
          .width('100%')
          .alignItems(VerticalAlign.Center);

          // 反馈
          Text("反馈 (给分不等于申请分值或不通过时写)")
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 16 });
          TextArea()
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .height(80)
            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12 })
            .onChange((text)=>{
              this.data!.FeedBack = text
            });

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
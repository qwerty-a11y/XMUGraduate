import router from '@ohos.router';
import { RecordEntry } from '../../datatypes/Record';
import * as ReviewComponents from '../../components/MainViews/Tea/ReviewComponents'

@Entry
@Component
struct Records {
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  private typeList: string[] = ['学业竞赛', '创新创业训练', '科研成果', '荣誉称号', '社会工作', '志愿服务', '国际组织学习', '参军入伍', '体育比赛']
  @State data?: RecordEntry = undefined;

  aboutToAppear(): void {
    this.data = router.getParams() as RecordEntry;
  }

  @Builder ExtraData(){
    if (this.data && this.data.Type.valueOf() == 0) {
      ReviewComponents.Competition({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 1) {
      ReviewComponents.Innovation({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 2) {
      ReviewComponents.Research({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 3) {
      ReviewComponents.Honor({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 4) {
      ReviewComponents.SocialWork({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 5) {
      ReviewComponents.Volunteer({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 6) {
      ReviewComponents.International({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 7) {
      ReviewComponents.Military({tmpentry:this.data})
    } else if (this.data && this.data.Type.valueOf() == 8) {
      ReviewComponents.Sports({tmpentry:this.data})
    }
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
            router.back();
          });
        Text("审核记录")
          .fontSize(16)
          .fontWeight(500)
          .width('55%')
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
          Text(this.data ? this.typeList[this.data.Type.valueOf()] : '')
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
          Text(this.data ? this.data.Title : '')
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
          Text(this.data ? this.data.Description : '')
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .constraintSize({ minHeight: 80 })
            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12, bottom: 12 });

          // 申请分值
          Row({ space: 10 }) {
            Text("申请分值")
              .fontSize(14)
              .width('60%')
              .fontColor('#666666')
            Text(this.data ? this.data.ApplyScore.toString() : '')
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center);

          // 自定义条件渲染控件
          this.ExtraData()

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
            Text(this.data ? this.data.RealScore.toString() : '')
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8);
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center);

          // 反馈
          Text("反馈")
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 16 });
          Text(this.data ? this.data.FeedBack : '')
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .constraintSize({ minHeight: 80 })
            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12 });

          // 操作按钮
          Row({ space: 20 }) {
            Button("重新审核")
              .fontSize(14)
              .fontWeight(500)
              .width(120)
              .height(44)
              .backgroundColor('#66ccff')
              .borderRadius(8);
            Button("撤销")
              .fontSize(14)
              .fontWeight(500)
              .width(120)
              .height(44)
              .backgroundColor('#66ccff')
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
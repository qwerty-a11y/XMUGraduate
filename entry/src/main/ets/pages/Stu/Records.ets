import router from '@ohos.router';
import { RecordEntry } from '../../datatypes/Record';
import * as RecordsComponents from '../../components/MainViews/Stu/RecordsComponents'

@Entry
@Component
struct Records {
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']
  private statusList:string[] = ['草稿','审核中','审核通过','审核失败']

  @State data?:RecordEntry=undefined;
  @State isTypeDropdownOpen: boolean = false;
  @State AllowEdit:boolean = false;

  @Builder ApplicationType(){
    Column() {
      ForEach(this.typeList, (option: string, index: number) => { // 明确循环变量类型
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            this.handleTypeSelect(option)
            this.data!.Type = index
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  aboutToAppear(): void {
    this.data = router.getParams() as RecordEntry
    if (this.data!.ReviewStatus == 0 || this.data!.ReviewStatus == 3){
      this.AllowEdit = true
    }
  }

  // 明确参数和返回值类型
  handleTypeSelect(type: string): void {
    this.isTypeDropdownOpen = false;
  }

  @Builder Buttons(){
    if (this.data?.ReviewStatus == 0){
      //--------------------草稿----------------------
      Row({ space: 20 }) {
        Button("保存")
          .fontSize(14)
          .fontWeight(500)
          .width(80)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8);
        Button("提交")
          .fontSize(14)
          .fontWeight(500)
          .width(80)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8);
        Button("删除")
          .fontSize(14)
          .fontWeight(500)
          .width(80)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8);
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 30 });
    } else if (this.data?.ReviewStatus == 1 || this.data?.ReviewStatus == 2) {
      //----------------非草稿页面---------------------
      Row({ space: 20 }) {
        Button("撤回并保存为草稿")
          .fontSize(14)
          .fontWeight(500)
          //.width(120)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8);
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 30 });
    } else if (this.data?.ReviewStatus == 3) {
      //-------------------被驳回-------------------
      // 操作按钮
      Row({ space: 20 }) {
        Button("重新提交")
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
  }

  @Builder FeedBack(){
    if (this.data?.Description != '') {
      //-------------------有反馈-------------------
      // 反馈
      Text("反馈 ")
        .fontSize(14)
        .width('90%')
        .fontColor('#666666')
        .margin({ left: 16 });
      Text(this.data!.Description)
        .fontSize(14)
        .fontColor('#333333')
        .backgroundColor('#e9e9e9')
        .width('90%')
        .height(80)
        .textAlign(TextAlign.Start)
        .borderRadius(8)
        .padding({ left: 12, top: 12 });
    }
  }

  @Builder ExtraData(){
    if (this.data!.Type.valueOf() == 0) {
      RecordsComponents.Competition({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 1) {
      RecordsComponents.Innovation({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 2) {
      RecordsComponents.Research({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 3) {
      RecordsComponents.Honor({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 4) {
      RecordsComponents.SocialWork({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 5) {
      RecordsComponents.Volunteer({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 6) {
      RecordsComponents.International({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 7) {
      RecordsComponents.Military({tmpentry:this.data})
    } else if (this.data!.Type.valueOf() == 8) {
      RecordsComponents.Sports({tmpentry:this.data})
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
            router.pushUrl({ url: 'pages/Stu/Main' ,params:{'page':1}});
          });
        Text("记录")
          .fontSize(16)
          .fontWeight(500)
          .width('50%')
          .margin({ right: 16 ,top:10,bottom:10});
      }
      .width('100%')
      .backgroundColor('#ddb3fade')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

      // 修复Scroll子组件问题：用一个Column包裹所有内容
      Scroll() {
        Column({ space: 16 }) { // 新增外层Column，作为Scroll的唯一子组件
          Row({ space: 10 }) {
            Text("状态：")
              .fontSize(14)
              .width('60%')
              .fontColor('#666666')
            Text(this.statusList[this.data!.ReviewStatus])
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
          }
          .width('90%')
          .margin({left:16,right:16})
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween);
          // 类型
          Row() {
            Text("类型")
              .fontSize(14)
              .fontColor('#666666')
            Button(this.typeList[this.data!.Type.valueOf()])
              .backgroundColor('#fff6f5f5')
              .fontColor(Color.Black)
              .onClick(() => {
                this.isTypeDropdownOpen = !this.isTypeDropdownOpen;
              })
              .bindMenu(this.isTypeDropdownOpen, this.ApplicationType)
              .width(200)
              .enabled(this.AllowEdit)
          }
          .margin({ left: 16 ,right:16})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('90%');

          // 名称
          Text("名称")
            .fontSize(14)
            .fontColor('#666666')
            .width('90%')
            .margin({ left: 16 })
            .enabled(this.AllowEdit);
          TextInput({text:this.data!.Title})
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .height(36)
            .borderRadius(8)
            .enabled(this.AllowEdit);

          // 详细描述
          Text("详细描述")
            .fontSize(14)
            .width('90%')
            .fontColor('#666666')
            .margin({ left: 16 });
          TextArea({text:this.data!.Description})
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#e9e9e9')
            .width('90%')
            .constraintSize({minHeight:80})
            .textAlign(TextAlign.Start)
            .borderRadius(8)
            .padding({ left: 12, top: 12 ,bottom:12})
            .enabled(this.AllowEdit);

          // 申请分值
          Row({ space: 10 }) {
            Text("申请分值")
              .fontSize(14)
              .width('60%')
              .fontColor('#666666')
            TextInput({text:this.data!.ApplyScore.toString()})
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
              .type(InputType.Number)
              .enabled(this.AllowEdit);
          }
          .width('90%')
          .margin({left:16,right:16})
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween);

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
            Text((this.data!.RealScore != -1)?this.data!.RealScore.toString():'未评分')
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor('#e9e9e9')
              .width(60)
              .height(36)
              .textAlign(TextAlign.Center)
              .borderRadius(8);
          }
          .width('90%')
          .margin({left:16,right:16})
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween);



          this.ExtraData()
          this.FeedBack()
          this.Buttons()

        }
        .width('100%') // 确保内部Column占满宽度
        .constraintSize({minHeight:'100%'})
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .padding({ top: 16 });
  }
}
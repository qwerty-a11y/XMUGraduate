import router from '@ohos.router';
import { RecordEntry } from '../../datatypes/Record';
import * as RecordsComponents from '../../components/MainViews/Stu/RecordsComponents'
import http from '@ohos.net.http';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../constants';
import { promptAction, PromptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

interface Application{
  Type:number
  Title:string
  ApplyScore:number
  RealScore:number
  ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  UploadTime:number
  ModifyTime:number
  Description:string
  Attachments:string[]
  FeedBack:string
  extra_data:string
}

interface empty{}

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

  async Save(opr:number):Promise<boolean>{
    if (this.data!.Title!='' && this.data!.ApplyScore!=0&&this.data!.Description!='') {
      let httpRequest = http.createHttp();
      let RequestData: Application = {
        'Type': this.data!.Type.valueOf(),
        'Title': this.data!.Title,
        'ApplyScore': this.data!.ApplyScore,
        'RealScore': this.data!.RealScore,
        'ReviewStatus': opr,
        'UploadTime': this.data!.UploadTime,
        'ModifyTime': Date.now(),
        'Description': this.data!.Description,
        'Attachments': this.data!.Attachments,
        'FeedBack': this.data!.FeedBack,
        'extra_data': this.data!.extra_data!.toJSON()
      }
      let RequestDataStr: string = json.stringify(RequestData)
      try {
        let Response: http.HttpResponse = await httpRequest.request(
          StaticData.ServerURL + '/api/student/material/applications/create/',
          {
            method: http.RequestMethod.PUT,
            extraData: RequestDataStr,
            header: {
              'Content-Type': 'application/json', // 关键：添加这个头
              'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
              'Authorization': 'Token '+DynamicData.token
            },
            connectTimeout:5000
          }
        )
        let DataObj: Object | empty
        let DataObjTmp: object | null
        try {
          DataObjTmp = json.parse(Response.result.toString())
          DataObj = DataObjTmp ? DataObjTmp : {}
          if (Response.responseCode == 200 && !(Object.keys(DataObj).includes('non_field_errors'))) {
            // 使用 promptAction 显示提示
            promptAction.showToast({
              message: '提交成功',
              duration: 2000 // 弹窗显示时间（毫秒）
            });
            return true
          } else {
            // 使用 promptAction 显示提示
            promptAction.showToast({
              message: '提交失败，请检查网络连接',
              duration: 2000 // 弹窗显示时间（毫秒）
            });
            return false
          }
        } catch (e) {
          let error = e as BusinessError
          let msg = error?.message
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '解析错误：' + msg,
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return false;
        }
      } catch (e) {
        let err: BusinessError = e as BusinessError
        console.log(err.message)
        console.log(err.name)
        return false
      }
    } else {
      // 使用 promptAction 显示提示
      promptAction.showToast({
        message: '请正确填写所有内容',
        duration: 2000 // 弹窗显示时间（毫秒）
      });
      return false
    }
  }

  async State(opr:boolean):Promise<boolean>{
    let httpRequest = http.createHttp();
    try {
      let URL:string
      switch (opr){
        case false:URL='/api/student/material/applications/withdraw/?UploadTime='+this.data!.UploadTime.toString();break;
        case true:URL='/api/student/material/applications/destroy/?UploadTime='+this.data!.UploadTime.toString();break;
      }
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + URL,
        {
          method: http.RequestMethod.DELETE,
          header: {
            'Content-Type': 'application/json', // 关键：添加这个头
            'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
            'Authorization': 'Token '+DynamicData.token
          },
          connectTimeout:5000
        }
      )
      let DataObj: Object | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}
        if (Response.responseCode == 200 && !(Object.keys(DataObj).includes('non_field_errors'))) {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '操作成功',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return true
        } else {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '操作失败，请检查网络连接',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return false
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        // 使用 promptAction 显示提示
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000 // 弹窗显示时间（毫秒）
        });
        return false;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
      return false
    }
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
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.Save(0)) router.back()
          });
        Button("提交")
          .fontSize(14)
          .fontWeight(500)
          .width(80)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.Save(1)) router.back()
          });
        Button("删除")
          .fontSize(14)
          .fontWeight(500)
          .width(80)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.State(true)) router.back()
          });
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
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.State(false)) router.back()
          });
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
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.Save(1)) router.back()
          });
        Button("撤销")
          .fontSize(14)
          .fontWeight(500)
          .width(120)
          .height(44)
          .backgroundColor('#66ccff')
          .borderRadius(8)
          .onClick(async ()=>{
            if (await this.State(false)) router.back()
          });
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

  @Builder ExtraData(disabled:boolean){
    if (this.data!.Type.valueOf() == 0) {
      RecordsComponents.Competition({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 1) {
      RecordsComponents.Innovation({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 2) {
      RecordsComponents.Research({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 3) {
      RecordsComponents.Honor({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 4) {
      RecordsComponents.SocialWork({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 5) {
      RecordsComponents.Volunteer({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 6) {
      RecordsComponents.International({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 7) {
      RecordsComponents.Military({tmpentry:this.data,isReadonly:disabled})
    } else if (this.data!.Type.valueOf() == 8) {
      RecordsComponents.Sports({tmpentry:this.data,isReadonly:disabled})
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
              .width(80)
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

          this.ExtraData(!this.AllowEdit)
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
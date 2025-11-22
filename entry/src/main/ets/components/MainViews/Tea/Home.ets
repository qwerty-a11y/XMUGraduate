import { Poster } from '../Stu/HomeComponents/TypeCard';
import router from '@ohos.router';
import { Attachment, RecordEntry } from '../../../datatypes/Record';
import { DateUtils } from '../../../utils';
import { TestData } from '../../../debug/TestData';
import http from '@ohos.net.http';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../../constants';
import * as RecordTypes from  '../../../datatypes/Record'
import { promptAction } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { BasicData } from '../../../service/Tea/BasicData';
import { AWARD_LEVELS } from '../../../datatypes/TypeInfoEnums';
import { ReviewData } from '../../../service/Tea/ReviewData';

interface Application{
  Type:number
  Title:string
  ApplyScore:number
  RealScore:number
  ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  UploadTime:number
  ModifyTime:number
  Description:string
  Attachments:Attachment[]
  FeedBack:string
  extra_data:string
}

interface data{
  ApplyList?: Application[]
}

interface empty{

}

export interface BasicResponse {
  college: string;
  created_at: string;
  id: string;
  major: string;
  name: string;
  school_id: string;
  updated_at: string;
}

@Component
export struct teaHomeView {
  @State homeNavBgColor: string = '#ffffffff';
  @Prop image_inform: ResourceStr = $r("app.media.inform");
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_set: ResourceStr = $r("app.media.Settings");
  @Prop image_search: ResourceStr = $r("app.media.Search");
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']

  // 列表数据，包含所有所需字段
  @State reviewList: RecordEntry[] = [];
/*
  async getApplications(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/student/material/reviews/pending_list/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )

      let DataObj: data | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}

        if (Response.responseCode == 200 && DataObj && (DataObj as data).ApplyList) {
          const applyList = (DataObj as data).ApplyList;
          this.reviewList = []

          for (const item of applyList!) {
            // 创建RecordEntry对象
            const recordEntry = new RecordTypes.RecordEntry(
              item.Type,
              item.Title,
              item.ApplyScore,
              item.ReviewStatus,
              item.Description,
              item.UploadTime,
              item.ModifyTime
            );

            recordEntry.RealScore = item.RealScore;
            recordEntry.Attachments = item.Attachments || [];
            recordEntry.FeedBack = item.FeedBack || '';

            // 解析extra_data
            if (item.extra_data && item.extra_data !== '') {
              try {
                const extraDataObj:object = JSON.parse(item.extra_data);
                let typeInfo: RecordTypes.TypeInfo | undefined;

                // 根据Type字段创建对应的TypeInfo对象
                switch (item.Type) {
                  case 0: // 学业竞赛
                    typeInfo = new RecordTypes.Competition();
                    break;
                  case 1: // 创新创业训练
                    typeInfo = new RecordTypes.Innovation();
                    break;
                  case 2: // 科研成果
                    typeInfo = new RecordTypes.Research();
                    break;
                  case 3: // 荣誉称号
                    typeInfo = new RecordTypes.Honor();
                    break;
                  case 4: // 社会工作
                    typeInfo = new RecordTypes.SocialWork();
                    break;
                  case 5: // 志愿服务
                    typeInfo = new RecordTypes.Volunteer();
                    break;
                  case 6: // 国际组织学习
                    typeInfo = new RecordTypes.International();
                    break;
                  case 7: // 参军入伍
                    typeInfo = new RecordTypes.Military();
                    break;
                  case 8: // 体育比赛
                    typeInfo = new RecordTypes.Sports();
                    break;
                  default:
                    console.warn('Unknown record type:', item.Type);
                }

                if (typeInfo) {
                  // 调用fromJSON方法解析数据
                  typeInfo.fromJSON(item.extra_data);
                  recordEntry.extra_data = typeInfo;
                }
              } catch (parseError) {
                console.error('Error parsing extra_data:', parseError);
              }
            }

            this.reviewList.push(recordEntry);
          }

        } else if (DataObj && Object.keys(DataObj).includes('detail')) {
          promptAction.showToast({
            message: '登录失效，请重新登录',
            duration: 2000
          });
          router.pushUrl({ url: 'pages/Login' })
        } else {
          promptAction.showToast({
            message: '刷新失败，请检查网络连接',
            duration: 2000
          });
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000
        });
        return;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
    }
  }
*/
  async getInformation(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/account/teacher/information/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json', // 关键：添加这个头
            'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )
      let DataObj: BasicResponse | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}
        if (Response.responseCode == 200 && (Object.keys(DataObj).length>0)) {
          BasicData.departments=(DataObj as BasicResponse).college+(DataObj as BasicResponse).major
        } else if (Object && Object.keys(DataObj).includes('detail')){
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '登录失效，请重新登录',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          router.pushUrl({ url: 'pages/Login' })
        } else {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '刷新失败，请检查网络连接',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        // 使用 promptAction 显示提示
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000 // 弹窗显示时间（毫秒）
        });
        return;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
    }
  }

  async aboutToAppear() {
    await ReviewData.refresh()
    await this.getInformation()
    emitter.on('back',()=>{
      this.reviewList=ReviewData.ReviewList
    })
    this.reviewList=ReviewData.ReviewList
  }

  // 列表项组件
  @Builder
  ReviewItemComponent(item: RecordEntry, index: number) {
    Column() {
      Row() {
        // 左侧主要信息区
        Column() {
          Text(`${item.Title}`)
            .fontSize(14)
            .fontColor('#000000')
            .margin({ right: 20 ,bottom:10});
          // 加分类别和提交时间
          Text(`类别：${this.typeList[item.Type.valueOf()]}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ right: 20 });
          Text(`上传时间：${DateUtils.ToString(item.UploadTime)}`)
            .fontSize(14)
            .fontColor('#666666');
        }
        .flexGrow(1)
        .padding({ left: 15 })
        .alignItems(HorizontalAlign.Start);

        // 右侧状态和处理时间区

      }
      .width('100%')
      .height(80)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        router.pushUrl({ url: 'pages/Tea/Review' ,params:item});
      });

      // 底部分隔线（最后一项不加）
      if (index+1 != this.reviewList.length) {
        Divider()
          .width('90%')
          .height(0.5)
          .color('#EEEEEE');
      }
    }
    .width('100%')
  }

  build() {
    Column() {
      // 顶部区域（保持不变）
      Column() {
        Row() {
          Text('Hi~')
            .fontSize(30)
            .margin({ top: 10, bottom: 5 });

          Image(this.image_set)
            .width(24)
            .height(24)
            .margin({ left: 8, right: 5 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Tea/Setting' });
            });
        }
        .width('90%')
        .height(60)
        .backgroundColor('#fff4fafa')
        .shadow({ radius: 10, color: '#00000010' })
        .justifyContent(FlexAlign.SpaceBetween)

        Poster()
          .width(343)
          .height(200)

        Row() {
          Text('保研条例参考')
            .fontSize(20)
            .margin({ left: 10, right: 10 })

          Image(this.image_world)
            .width(24)
            .margin({ left: 10, right: 10, top: 10, bottom: 10 })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor('#84F2C3')
        .borderRadius(20)
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Tea/Rules' });
        });

        Text('若有新的审核，请及时处理')
          .fontSize(14)
          .width('86%')
          .margin({ top: 10, bottom: 10 })
      }
      .width('100%')
      .backgroundColor('#F4FAFA')

      // 可滚动列表区域
      Scroll() {
        Column() {
          // 列表容器
          Column() {
            ForEach(this.reviewList, (item: RecordEntry, index: number) => {
              this.ReviewItemComponent(item, index)
                // .onClick(() => {
                //   // 点击列表项跳转到详情页
                //   router.pushUrl({ url: `pages/ReviewDetail?id=${item.id}` });
                // });
            })
          }
          .width('90%')
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .shadow({
            radius: 4,
            color: '#00000010',
            offsetX: 0,
            offsetY: 2
          })
        }
        .width('100%')
        .constraintSize({minHeight:'100%'})
      }
      .height('39%') // 设置滚动区域高度为屏幕的50%，可根据需要调整
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}
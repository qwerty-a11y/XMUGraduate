import router from '@ohos.router';
import { Account } from '../../datatypes/Account';
import { RecordEntry } from '../../datatypes/Record';
import { TestData } from '../../debug/TestData';
import { DateUtils } from '../../utils';
import http from '@ohos.net.http';
import json from '@ohos.util.json';
import * as RecordTypes from '../../datatypes/Record'
import { DynamicData, StaticData } from '../../constants';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

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

interface data{
  ApplyList?: Application[]
}

interface empty{

}

@Entry
@Component
export struct teacheck {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @Prop image_uploadtime: ResourceStr = $r("app.media.RecordEntry_UploadTime");
  @Prop image_modifytime: ResourceStr = $r("app.media.RecordEntry_ModifyTime");
  @Prop image_filter: ResourceStr = $r("app.media.Filter");
  @State SearchText: string = '';
  private typeList: string[] = ['学业竞赛', '创新创业训练', '科研成果', '荣誉称号', '社会工作', '志愿服务', '国际组织学习', '参军入伍', '体育比赛']

  @State historyList: RecordEntry[] = TestData.RecordList;
  @State account?:Account = undefined

  // 根据状态返回显示文本
  getStatusText(status: number): string {
    if (status == 2) return '已通过';
    if (status == 3) return '已驳回';
    return ''
  }

  // 根据状态返回文本颜色
  getStatusColor(status: number): ResourceColor {
    if (status == 2) return '#00B42A';
    if (status == 3) return '#F53F3F';
    return ''
  }

  async refresh(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/student/material/applications/list/',
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
          this.historyList = []

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

            this.historyList.push(recordEntry);
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

  aboutToAppear(): void {
   this.account=router.getParams() as Account
  }

  build() {
    Column() {
      // 顶部搜索及历史记录标题区域
      Column() {
        Row() {
          Image(this.image_back)
            .width(24)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Super/Individual' ,params:this.account});
            });

          Row() {
            Image(this.image_search)
              .width(24)
              .height(24)
              .margin({ left: 12 });
            TextInput({
              placeholder: 'Search',
              text: this.SearchText
            })
              .fontSize(16)
              .height(32)
              .backgroundColor('white')
              .placeholderColor('#999999')
              .margin({ left: 8 })
              .layoutWeight(1);
          }
          .backgroundColor('white')
          .borderRadius(20)
          .height(52)
          .width(280)
          .shadow({
            radius: 4,
            color: '#10000000',
            offsetX: 0,
          });

          Image(this.image_filter)
            .width(24)
            .margin({ left: 10 })
        }

        Text('历史记录')
          .fontSize(14)
          .width('90%')
          .margin({ top: 10 });
      }
      .width('100%')
      .height('15%')
      .justifyContent(FlexAlign.Center);

      // 可滚动历史记录列表
      Scroll() {
        Column() {
          ForEach(this.historyList, (item: RecordEntry) => {
            Row() {
              Column() {
                Text(`${item.Title}`)
                  .fontSize(14)
                  .margin({ bottom: 4 });
                Text(`加分类别：${this.typeList[item.Type.valueOf()]}`)
                  .fontSize(14)
                  .margin({ bottom: 4 });
                Text(`状态：${this.getStatusText(item.ReviewStatus)}`)
                  .fontSize(14)
                  .fontColor(this.getStatusColor(item.ReviewStatus))
                  .margin({ bottom: 4 });
              }
              .margin({ left: 10, right: 10, top: 10, bottom: 10 })
              .layoutWeight(1)

              Column() {
                Row() {
                  Image(this.image_uploadtime)
                    .width(12)
                  Text(`${DateUtils.ToString(item.UploadTime)}`)
                    .fontSize(14);
                }
                .margin({ bottom: 8 })

                Row() {
                  Image(this.image_modifytime)
                    .width(12)
                  Text(`${DateUtils.ToString(item.ModifyTime)}`)
                    .fontSize(14);
                }
              }
              .margin({ left: 10, right: 10, top: 10, bottom: 10 })
              .alignItems(HorizontalAlign.End)
            }
            .width('90%')
            .backgroundColor('white')
            .borderRadius(10)
            .margin({ bottom: 8 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Super/Tearecords',
                params: item
              });
            });
          });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);
      }
      .height('75%')
      .width('100%')
      .margin({ bottom: 100 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
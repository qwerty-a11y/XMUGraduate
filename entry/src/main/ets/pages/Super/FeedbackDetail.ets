import router from '@ohos.router';
import http from '@ohos.net.http';
import { DynamicData, StaticData } from '../../constants';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { Request } from '../../datatypes/Feedback'
import { FeedBacks } from '../../service/Super/AccountList';

interface requestData{
  UploadTime:number
}

@Entry
@Component
struct FeedbackDetail {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @State data?:Request=undefined;

  aboutToAppear(): void {
    this.data = router.getParams() as Request
  }

  async solved(): Promise<boolean> {
    const httpRequest = http.createHttp();

    try {
      const requestData:requestData = {
        UploadTime:this.data!.UploadTime
      };

      const response: http.HttpResponse = await httpRequest.request(
        `${StaticData.ServerURL}/api/feedback/setsolved/`, // 请替换为实际API路径
        {
          method: http.RequestMethod.PUT,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Token ${DynamicData.token}`
          },
          extraData: JSON.stringify(requestData),
          connectTimeout: 5000
        }
      );

      // 只需要检查状态码，不需要解析响应内容
      return response.responseCode === 200;

    } catch (error) {
      const err = error as BusinessError;
      console.log(`请求发送失败: ${err.message}`);
      return false;
    }
  }

  async delete(): Promise<boolean> {
    const httpRequest = http.createHttp();

    try {
      const requestData:requestData = {
        UploadTime:this.data!.UploadTime
      };

      const response: http.HttpResponse = await httpRequest.request(
        `${StaticData.ServerURL}/api/feedback/delete/`, // 请替换为实际API路径
        {
          method: http.RequestMethod.DELETE,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Token ${DynamicData.token}`
          },
          extraData: JSON.stringify(requestData),
          connectTimeout: 5000
        }
      );

      // 只需要检查状态码，不需要解析响应内容
      return response.responseCode === 200;

    } catch (error) {
      const err = error as BusinessError;
      console.log(`请求发送失败: ${err.message}`);
      return false;
    }
  }

  build() {
    RelativeContainer() {
      Text("反馈详情")
        .fontSize(16)
        .fontWeight(500)
        .height(40)
        .id('title')
        .alignRules({
          top:{anchor:'__container__',align:VerticalAlign.Top},
          middle:{anchor:'__container__',align:HorizontalAlign.Center}
        })
      Image(this.image_back)
        .width(24)
        .height(24)
        .margin({ left: 16 })
        .onClick(() => {
          router.back()
        })
        .alignRules({
          center:{anchor:'title',align:VerticalAlign.Center}
        })
      Column({ space: 16 }) {
        Row() {
          Text("来源")
            .fontSize(16)
            .fontColor('#666666')
          Text(this.data?.Name + " " + (this.data?.Identity ? '老师' : '学生'))
            .fontSize(16)
            .fontColor('#333333')
            .height(36)
            .textAlign(TextAlign.Center)
            .borderRadius(8);
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .margin({top:20})


        // 详细描述
        Text("详情")
          .fontSize(16)
          .width('90%')
          .fontColor('#666666')
          .margin({ left: 16, right: 16 ,top:16});
        Text(this.data?.Content)
          .fontSize(16)
          .fontColor('#333333')
          .backgroundColor('#e9e9e9')
          .width('90%')
          .constraintSize({ minHeight: 80 })
          .textAlign(TextAlign.Start)
          .borderRadius(8)
          .padding(12)
          .margin({top:8})

      }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .id('main')
        .alignRules({
          top:{anchor:'title',align:VerticalAlign.Bottom},
          middle:{anchor:'__container__',align:HorizontalAlign.Center}
        })
      Column(){
        // 操作按钮
        if (this.data?.Status) {
          Button("删除记录")
            .fontSize(14)
            .fontWeight(500)
            .width(200)
            .height(44)
            .backgroundColor('#fff84646')
            .borderRadius(8)
            .onClick(async () => {
              if (await this.delete()) {
                await FeedBacks.Refresh()
                emitter.emit('back')
                router.back()
              }
            })
        } else {
          Button("已完成")
            .fontSize(14)
            .fontWeight(500)
            .width(200)
            .height(44)
            .backgroundColor('#66ccff')
            .borderRadius(8)
            .onClick(async () => {
              if (await this.solved()) {
                await FeedBacks.Refresh()
                emitter.emit('back')
                router.back()
              }
            })
        }
      }
        .id('button')
        .alignRules({
          bottom:{anchor:'__container__',align:VerticalAlign.Bottom},
          middle:{anchor:'__container__',align:HorizontalAlign.Center}
        })
        .margin({bottom:40})
    }
    .width('100%')
  }
}
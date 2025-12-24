import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { http } from '@kit.NetworkKit';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../constants';
import { BusinessError } from '@kit.BasicServicesKit';

interface data{
  content:string
}
interface empty{}

@Entry
@Component
struct FeedbackPage {
  // @Prop 必须定义在组件顶层，不能放在 build 方法内
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");

  // 反馈内容状态管理
  @State feedbackContent: string = '';
  @State errorMessage: string = '';

  async Submit():Promise<boolean>{
    let httpRequest = http.createHttp();
    let RequestData: data = {
      content:this.feedbackContent
    }
    let RequestDataStr: string = json.stringify(RequestData)
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/feedback/create/',
        {
          method: http.RequestMethod.POST,
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
  }

  // 提交反馈
  async submitFeedback() {
    // 简单验证
    if (!this.feedbackContent.trim()) {
      this.errorMessage = '请输入反馈内容';
      return;
    }

    if (this.feedbackContent.length < 5) {
      this.errorMessage = '反馈内容不能少于5个字符';
      return;
    }

    if (await this.Submit()) {
    // 模拟提交成功
    this.errorMessage = '';
    promptAction.showToast({
      message: '反馈提交成功，感谢您的建议！',
      duration: 2000
    })
    }

    // 返回设置页
    setTimeout(() => {
      router.back()
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
            router.back()
          });

        Text('反馈')
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

      // 反馈内容输入区域
      Column() {
        Text('请输入您的反馈或建议')
          .fontSize(14)
          .margin({ bottom: 10, left: 2, top: 20 })
          .alignSelf(ItemAlign.Start);

        TextArea({ placeholder: '请详细描述您遇到的问题或建议...' })
          .width('100%')
          .height(200)
          .backgroundColor('#ffffff')
          .borderRadius(8)
          .padding(12)
          .maxLength(500) // 限制最大输入长度
          .onChange((value: string) => {
            this.feedbackContent = value;
          });

        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#ff3b30')
            .margin({ top: 10, bottom: 10 })
            .alignSelf(ItemAlign.Start);
        }

        // 字符计数提示
        Text(`${this.feedbackContent.length}/500`)
          .fontSize(12)
          .fontColor('#888888')
          .margin({ bottom: 20 })
          .alignSelf(ItemAlign.End);

        // 提交按钮
        Button('提交反馈')
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#ff77f0ec')
          .borderRadius(8)
          .onClick(() => this.submitFeedback());

      }
      .width('90%')
      .flexGrow(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}

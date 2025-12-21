import { promptAction, router } from '@kit.ArkUI'
import { DynamicData, StaticData } from '../constants'
import { BusinessError} from '@kit.BasicServicesKit'
import { http } from '@kit.NetworkKit'
import json from '@ohos.util.json'

interface _2FARequest{
  code:string
}
interface empty{}

@Entry
struct Confirm2FA{
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @State code:string=''

  async submit() {
    if (this.code.length == 6) {
      let httpRequest = http.createHttp();
      let RequestData: _2FARequest = {
        'code': this.code
      }
      let RequestDataStr: string = json.stringify(RequestData)
      try {
        let Response: http.HttpResponse = await httpRequest.request(
          StaticData.ServerURL + '/api/auth/2fa/confirm/',
          {
            method: http.RequestMethod.POST,
            extraData: RequestDataStr,
            header: {
              'Content-Type': 'application/json', // 关键：添加这个头
              'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
              'Authorization': "Token "+DynamicData.token
            },
            connectTimeout:5000
          }
        )
        let DataObj: Object | empty
        let DataObjTmp: object | null
        try {
          DataObjTmp = json.parse(Response.result.toString())
          DataObj = DataObjTmp ? DataObjTmp : {}
          if (Response.responseCode == 200 && DataObj && !(Object.keys(DataObj).includes('non_field_errors'))) {
            let obj=DataObj as Record<string, string>
            switch (DynamicData.account_type){
              case 0:router.pushUrl({url:'pages/Stu/Main'});break;
              case 1:router.pushUrl({url:'pages/Tea/Main'});break;
              case 2:router.pushUrl({url:'pages/Super/Main'});break;
            }
          } else {
            // 使用 promptAction 显示提示
            promptAction.showToast({
              message: '验证码错误，请重试',
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
    } else {
      // 使用 promptAction 显示提示
      promptAction.showToast({
        message: '验证码格式有误',
        duration: 2000 // 弹窗显示时间（毫秒）
      });
    }
  }

  build() {
    RelativeContainer(){
      Text("添加双因素验证").fontSize(20)
        .height(40)
        .width('100%')
        .backgroundColor('#ffd6f8f8')
        .width('100%')
        .textAlign(TextAlign.Center)
        .id('title')
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Image(this.image_back).width(24).height(24).margin(10)
        .id('back')
        .alignRules({
          left:{anchor:'__container__',align:HorizontalAlign.Start},
          center:{anchor:'title',align:VerticalAlign.Center}
        })
        .onClick(()=>{router.back()})
      Text("在下面的输入框中输入您获取到的六位数验证码，确认添加完成").fontSize(16).padding({top:60,left:20})
        .id('text1')
        .alignRules({
          top:{anchor:'title',align:VerticalAlign.Bottom},
          left:{anchor:'__container__',align:HorizontalAlign.Start}
        })
      TextInput().fontSize(36).type(InputType.Number).maxLength(6).textAlign(TextAlign.Center).margin({top:40})
        .backgroundColor(Color.Transparent)
        .borderRadius(0)
        .width('80%')
        .border({width:{bottom:1},color:Color.Black})
        .onChange(text=>{this.code=text})
        .alignRules({
          top:{anchor:'text1',align:VerticalAlign.Bottom},
          middle:{anchor:'__container__',align:HorizontalAlign.Center}
        })
      Button(){
        Text("确定")
      }.onClick(()=>{
        this.submit()
      }).width(200).height(50).margin({bottom:40}).backgroundColor('#d877d9c2').borderRadius(25)
      .id('confirm')
      .alignRules({
        middle:{anchor:'__container__',align:HorizontalAlign.Center},
        bottom:{anchor:'__container__',align:VerticalAlign.Bottom}
      })
    }
  }
}
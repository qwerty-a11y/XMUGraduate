import { promptAction, router } from '@kit.ArkUI'
import { DynamicData, StaticData } from '../constants'
import { BusinessError, pasteboard } from '@kit.BasicServicesKit'
import { http } from '@kit.NetworkKit'
import json from '@ohos.util.json'

interface data{
  secret:string,
  QRCode:string
}

@Entry
struct Add2FA{
  @State secret:string=''
  @State uri:string=''
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  //private QRBitMap:PixelMap|undefined = undefined
  @State QRBase64:string=''

  async request() {
    const httpRequest = http.createHttp();
    try {
      const response: http.HttpResponse = await httpRequest.request(
        `${StaticData.ServerURL}/api/auth/2fa/setup/`, // 请替换为实际API路径
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Token ${DynamicData.token}`
          },
          connectTimeout: 5000
        }
      );

      if (response.responseCode === 200) {
        let DataObj:data
        if(typeof(response.result)==typeof("")){
          DataObj=json.parse(response.result as string) as data
        } else {
          DataObj = response.result as data
        }
        this.secret=DataObj.secret
        this.QRBase64=DataObj.QRCode
        this.uri="otpauth://totp/XMUGraduate:"+DynamicData.account_id+"?secret="+this.secret+"&issuer=XMUGraduate"
        //this.QRBitMap = await generateBarcode.createBarcode(this.uri,{scanType:11,width:1024,height:1024})
      } else {
        promptAction.showToast({
          message: `请求2FA验证信息失败`,
          duration: 2000
        });
      }
    } catch (requestError) {
      const error = requestError as BusinessError;
      console.log(`请求错误: ${error.message}`);
      promptAction.showToast({
        message: '网络请求失败，请检查网络连接',
        duration: 2000
      });
    }
  }

  aboutToAppear() {
    this.request()
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


      Text("为了您的账号安全，请按指引添加双因素验证").fontSize(16).margin({top:20,left:20})
        .id('text1')
        .alignRules({
          top:{anchor:'title',align:VerticalAlign.Bottom},
          left:{anchor:'__container__',align:HorizontalAlign.Start}
        })
      Text("请安装Google Authenticator或Microsoft Authenticator，并扫描下方二维码").fontSize(16).padding({left:20})
        .id('text2')
        .alignRules({
          top:{anchor:'text1',align:VerticalAlign.Bottom},
          left:{anchor:'__container__',align:HorizontalAlign.Start}
        })
      Image(this.QRBase64).width('80%').aspectRatio(1).margin({top:40})
        .id('QR')
        .alignRules({
          middle:{anchor:'__container__',align:HorizontalAlign.Center},
          top:{anchor:'text2',align:VerticalAlign.Bottom}
        })
      Text("或复制密钥，在软件中输入").fontSize(16).padding({left:20,top:40})
        .id('text3')
        .alignRules({
          top:{anchor:'QR',align:VerticalAlign.Bottom},
          left:{anchor:'__container__',align:HorizontalAlign.Start}
        })
      Button(){
        Text("复制密钥")
      }.onClick(async ()=>{
        let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN,this.secret)
        let systemPasteboard = pasteboard.getSystemPasteboard();
        await systemPasteboard.setData(pasteData);
        promptAction.showToast({
          message:"复制成功",
          duration:2000
        })
      }).width(100).height(40).margin({top:20}).backgroundColor('#ffd6f8f8')
      .id('button')
      .alignRules({
        middle:{anchor:'__container__',align:HorizontalAlign.Center},
        top:{anchor:'text3',align:VerticalAlign.Bottom}
      })
      Button(){
        Text("我已完成，下一步")
      }.onClick(()=>{
        router.pushUrl({url:'pages/Confirm2FA'})
      }).width(200).height(50).margin({bottom:60}).backgroundColor('#d877d9c2').borderRadius(25)
      .id('confirm')
      .alignRules({
        middle:{anchor:'__container__',align:HorizontalAlign.Center},
        bottom:{anchor:'__container__',align:VerticalAlign.Bottom}
      })
    }
  }
}
import * as TypeRecord from '../../../../datatypes/Record'
import { LengthMetrics } from '@kit.ArkUI'
import { UploadsData } from '../../../../service/Stu/UploadsData'
import { DateUtils } from '../../../../utils'
import { TimeSpan } from '../../../../datatypes/Record'

@CustomDialog
@Component
export struct _2FADialog{
  public controller:CustomDialogController
  @Require title:string
  @Require text:string
  @Require public confirm:(code:string) => void
  @Require public cancel: () => void
  @State code:string=''

  build() {
    Column(){
      Text(this.title).fontSize(24)
      Text(this.text).fontSize(16).padding({top:20})
      Text('输入您的TOTP验证码来验证您的身份').fontSize(14).padding({top:10})
      TextInput().fontSize(36).type(InputType.Number).maxLength(6).textAlign(TextAlign.Center)
        .backgroundColor(Color.Transparent)
        .borderRadius(0)
        .border({width:{bottom:1},color:Color.Black})
        .onChange(text=>{this.code=text})
      Row({space:30}){
        Button(){
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)
        Button(){
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(()=>{this.confirm(this.code)})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Center)
  }
}
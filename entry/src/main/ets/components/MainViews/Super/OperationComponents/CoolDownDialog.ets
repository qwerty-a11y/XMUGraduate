import * as TypeRecord from '../../../../datatypes/Record'
import { LengthMetrics } from '@kit.ArkUI'
import { UploadsData } from '../../../../service/Stu/UploadsData'
import { DateUtils } from '../../../../utils'
import { TimeSpan } from '../../../../datatypes/Record'

@CustomDialog
@Component
export struct CoolDownDialog{
  public controller:CustomDialogController
  @Require title:string
  @Require text:string
  @Require CoolDown:number
  @Require public confirm:() => void
  @Require public cancel: () => void
  @State ConfirmText:string=''
  @State CurCoolDown:number=0

  private sleep(time: number): Promise<string> {
    return new Promise<string>((resolve) => {
      setTimeout(() => {
        resolve('ok')
      }, time)
    });
  }

  async timer(){
    while(this.CurCoolDown>0){
      await this.sleep(1000)
      this.CurCoolDown=this.CurCoolDown-1
      this.ConfirmText='确定('+String(this.CurCoolDown)+')'
    }
    this.ConfirmText='确定'
  }

  aboutToAppear(): void {
    this.CurCoolDown=this.CoolDown
    this.ConfirmText='确定('+String(this.CurCoolDown)+')'
    this.timer()
  }

  build() {
    Column(){
      Text(this.title).fontSize(24)
      Text(this.text).fontSize(16).padding({top:20})
      Row({space:30}){
        Button(){
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)
        Button(){
          Text(this.ConfirmText).fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB')
        .enabled(this.CurCoolDown<=0)
        .onClick(()=>{this.confirm()})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Center)
  }
}
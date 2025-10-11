import * as TypeRecord from '../../../datatypes/Record'
import { LengthMetrics } from '@kit.ArkUI'
import { UploadsData } from '../../../service/UploadsData'
import { DateUtils } from '../../../utils'
import { TimeSpan } from '../../../datatypes/Record'

@CustomDialog
@Component
export struct Filter_TimeSpanDialog{
  public controller:CustomDialogController
  @Require NewTime:number
  @Require public confirm:(NewTime:number) => void
  @Require public cancel: () => void

  build() {
    Column(){
      Row({space:30}){
        Button(){
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)
        Button(){
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(()=>{this.confirm(this.NewTime)})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Start)
  }
}
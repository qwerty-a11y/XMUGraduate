import * as TypeRecord from '../../../datatypes/Record'
import { LengthMetrics } from '@kit.ArkUI'
import { UploadsData } from '../../../service/UploadsData'

@CustomDialog
@Component
export struct FilterDialog{
  public controller:CustomDialogController
  @Require public confirm:(NewFilter:TypeRecord.Filter) => void
  @Require public cancel: () => void
  NewFilter:TypeRecord.Filter = UploadsData.Filters.clone()
  @State status:boolean[] = this.NewFilter.ReviewStatus
  @State type:boolean[] = this.NewFilter.Type
  statusList:string[] = ['待提交','审核中','审核成功','审核失败']
  typeList:string[] = ['学业竞赛','创新创业训练','学术研究','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍']

  @Builder
  statusSwitch(text:string,index:number){
    Button(){
      Text(text).fontSize(14)
    }.borderRadius('100%')
    .padding({top:5,bottom:5,left:15,right:15})
    .margin({right:10,bottom:10})
    .backgroundColor(this.status[index]==true?'#AAFAFB':'#E5E5E5')
    .onClick(()=>{
      this.status[index]=!this.status[index]
    })
  }

  @Builder
  typeSwitch(text:string,index:number){
    Button(){
      Text(text).fontSize(14)
    }.borderRadius('100%')
    .padding({top:5,bottom:5,left:15,right:15})
    .margin({right:10,bottom:10})
    .backgroundColor(this.type[index]==true?'#AAFAFB':'#E5E5E5')
    .onClick(()=>{
      this.type[index]=!this.type[index]
    })
  }

  build() {
    Column(){
      Text('状态').fontSize(20).margin({bottom:10})
      Flex({ wrap: FlexWrap.Wrap}){
        ForEach(this.statusList,(text:string,index:number)=>{
          this.statusSwitch(text,index)
        })
      }
      Text('学业专长').fontSize(20).margin({top:10,bottom:10})
      Flex({ wrap: FlexWrap.Wrap, space: {main: LengthMetrics.px(15), cross: LengthMetrics.px(15)} }){
        ForEach(this.typeList.slice(0,3),(text:string,index:number)=>{
          this.typeSwitch(text,index)
        })
      }
      Text('综合表现').fontSize(20).margin({top:10,bottom:10})
      Flex({ wrap: FlexWrap.Wrap, space: {main: LengthMetrics.px(15), cross: LengthMetrics.px(15)} }){
        ForEach(this.typeList.slice(3,8),(text:string,index:number)=>{
          this.typeSwitch(text,index+3)
        })
      }
      Row({space:30}){
        Button(){
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)
        Button(){
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(()=>{this.confirm(this.NewFilter)})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Start)
  }
}
import * as TypeRecord from '../../../../datatypes/Record'
import { LengthMetrics } from '@kit.ArkUI'
import { UploadsData } from '../../../../service/Stu/UploadsData'
import { TimeSpan } from '../../../../datatypes/Record'
import { Filter_TimeSpanDialog } from './Filter_TimeSpanDialog'

@Component
struct TimeSpanBox {
  TimeSpanDialogInstance?:CustomDialogController
  @Link value:TimeSpan
  build() {
    Row() {
      Button() {
        Text(this.value.ToStringStart)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(12)
      }
      .width(100)
      .backgroundColor('#CCCCCC')
      .borderRadius(50)
      .padding({
        top: 5,
        bottom: 5
      })
      .onClick(() => {
        this.TimeSpanDialogInstance = new CustomDialogController({
          builder: Filter_TimeSpanDialog(
            {
              confirm: (NewTime: number) => {
                this.value = new TimeSpan(NewTime, this.value.end)
                this.TimeSpanDialogInstance?.close()
              },
              cancel: () => {
                this.TimeSpanDialogInstance?.close()
              },
              remove: () => {
                this.value = new TimeSpan(-1, this.value.end)
                this.TimeSpanDialogInstance?.close()
              },
              OldTime: this.value.start
            }),
          alignment: DialogAlignment.Bottom,
          autoCancel: true
        })
        this.TimeSpanDialogInstance?.open()
      })

      Text('-')
      Button() {
        Text(this.value.ToStringEnd)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(12)
      }
      .width(100)
      .backgroundColor('#CCCCCC')
      .borderRadius(50)
      .padding({
        top: 5,
        bottom: 5
      })
      .onClick(() => {
        this.TimeSpanDialogInstance = new CustomDialogController({
          builder: Filter_TimeSpanDialog(
            {
              confirm: (NewTime: number) => {
                this.value = new TimeSpan(this.value.start, NewTime)
                this.TimeSpanDialogInstance?.close()
              },
              cancel: () => {
                this.TimeSpanDialogInstance?.close()
              },
              remove: () => {
                this.value = new TimeSpan(this.value.start, -1)
                this.TimeSpanDialogInstance?.close()
              },
              OldTime: this.value.end
            }),
          alignment: DialogAlignment.Bottom,
          autoCancel: true
        })
        this.TimeSpanDialogInstance.open()
      })
    }.justifyContent(FlexAlign.SpaceAround).flexGrow(1)
  }
}

@CustomDialog
@Component
export struct FilterDialog{
  public controller:CustomDialogController
  @Require public confirm:(NewFilter:TypeRecord.Filter) => void
  @Require public cancel: () => void
  NewFilter:TypeRecord.Filter = UploadsData.Filters.clone()
  @State status:boolean[] = this.NewFilter.ReviewStatus
  @State type:boolean[] = this.NewFilter.Type
  @State EnableStatus:boolean = this.NewFilter.EnableStatus
  @State EnableType:boolean = this.NewFilter.EnableType
  @State @Watch('UpdateUpload') UploadTime:TimeSpan= UploadsData.Filters.UploadTime
  @State @Watch('UpdateModify') ModifyTime:TimeSpan = UploadsData.Filters.ModifyTime
  statusList:string[] = ['待提交','审核中','审核成功','审核失败']
  typeList:string[] = ['学业竞赛','创新创业训练','学术研究','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']
  animateParams:AnimateParam[] = [
    {
      duration:125,
      delay:250,
      curve:Curve.EaseInOut
    },
    {
      duration:125,
      curve:Curve.EaseInOut
    }
  ]
  customAnimate = TransitionEffect.asymmetric(
    TransitionEffect.translate({y:'-20'}).combine(TransitionEffect.opacity(0)).animation({
      delay:125,
      duration:250,
      curve:Curve.EaseInOut
    }),
    TransitionEffect.translate({y:'-20'}).combine(TransitionEffect.opacity(0)).animation({
      duration:250,
      curve:Curve.EaseInOut
    }),
  )
  FirstLoad = TransitionEffect.IDENTITY
  @State EnableAnimation:boolean = false

  log(){
    console.log('modify')
  }

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

  UpdateUpload(){
    this.NewFilter.UploadTime = this.UploadTime
  }

  UpdateModify(){
    this.NewFilter.ModifyTime = this.ModifyTime
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Text('按状态筛选').fontSize(20).margin({ bottom: 10 })
            Toggle({ type: ToggleType.Switch, isOn: this.EnableStatus })
              .onChange((isOn) => {
                this.EnableAnimation = true
                this.NewFilter.EnableStatus = isOn
                this.EnableStatus = isOn
              })
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.statusList, (text: string, index: number) => {
              this.statusSwitch(text, index)
            })
          }.visibility(this.EnableStatus ? Visibility.Visible : Visibility.Hidden)
          .transition((!this.EnableAnimation && this.EnableStatus) ? this.FirstLoad : this.customAnimate)
          .height(this.EnableStatus ? 'auto' : 1).animation(this.animateParams[Number(this.EnableStatus)])

          Row() {
            Text('按项目类别筛选').fontSize(20).margin({ bottom: 10 })
            Toggle({ type: ToggleType.Switch, isOn: this.EnableType })
              .onChange((isOn) => {
                this.EnableAnimation = true
                this.NewFilter.EnableType = isOn
                this.EnableType = isOn
              })
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')

          Column() {
            Text('学业专长').fontSize(18).margin({ top: 10, bottom: 10 })
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.px(15), cross: LengthMetrics.px(15) } }) {
              ForEach(this.typeList.slice(0, 3), (text: string, index: number) => {
                this.typeSwitch(text, index)
              })
            }

            Text('综合表现').fontSize(18).margin({ top: 10, bottom: 10 })
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.px(15), cross: LengthMetrics.px(15) } }) {
              ForEach(this.typeList.slice(3, 9), (text: string, index: number) => {
                this.typeSwitch(text, index + 3)
              })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .visibility(this.EnableType ? Visibility.Visible : Visibility.Hidden)
          .transition((!this.EnableAnimation && this.EnableType) ? this.FirstLoad : this.customAnimate)
          .height(this.EnableType ? 'auto' : 1)
          .animation(this.animateParams[Number(this.EnableType)])

          Text('时间区间').fontSize(20).margin({ bottom: 10 })
          Column() {
            Row() {
              Text('上传时间').fontSize(14).margin({ top: 10, bottom: 10 })
              TimeSpanBox({value:this.UploadTime})
            }.width('100%')

            Row() {
              Text('修改时间').fontSize(14).margin({ top: 10, bottom: 10 })
              TimeSpanBox({value:this.ModifyTime})
            }.width('100%')
          }.width('100%')
        }.alignItems(HorizontalAlign.Start)
      }.constraintSize({maxHeight:'80%'})

      Row({ space: 30 }) {
        Button() {
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)

        Button() {
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(() => {
          this.confirm(this.NewFilter)
        })
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({ top: 20 }).displayPriority(2)
    }.padding(20).alignItems(HorizontalAlign.Start)
  }
}
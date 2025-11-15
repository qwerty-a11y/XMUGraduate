@CustomDialog
@Component
export struct TimeSpanDialog{
  public controller:CustomDialogController
  @Require OldTime:number
  @Require public confirm:(NewTime:number) => void
  @Require public cancel: () => void
  private TempDate?:Date = undefined

  submit(){
    let newYear:number=0
    let newMonth:number=0
    let newDay:number=0
    if (this.TempDate==undefined) this.TempDate=this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
    newYear=this.TempDate.getFullYear()
    newMonth=this.TempDate.getMonth()
    newDay=this.TempDate.getDate()
    return (new Date(newYear,newMonth,newDay)).getTime()
  }

  build() {
    Column(){
      Row(){
        DatePicker({
          start:new Date('2000-01-01'),
          end:new Date('2099-12-31'),
          selected:this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
        }).width('100%').onDateChange((Date)=>{this.TempDate=Date})
      }
      Row({space:30}){
        Button(){
          Text('取消').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.cancel)
        Button(){
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(()=>{this.confirm(this.submit())})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Start)
  }
}
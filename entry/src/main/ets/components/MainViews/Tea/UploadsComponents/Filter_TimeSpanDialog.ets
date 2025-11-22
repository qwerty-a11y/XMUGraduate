

@CustomDialog
@Component
export struct Filter_TimeSpanDialog{
  public controller:CustomDialogController
  @Require OldTime:number
  @Require public confirm:(NewTime:number) => void
  @Require public cancel: () => void
  @Require public remove: () => void
  private TempDate?:Date = undefined
  private TempTime?:TimePickerResult = undefined

  submit(){
    let newYear:number=0
    let newMonth:number=0
    let newDay:number=0
    let newHour:number=0
    let newMinute:number=0
    if (this.TempDate==undefined) this.TempDate=this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
    newYear=this.TempDate.getFullYear()
    newMonth=this.TempDate.getMonth()
    newDay=this.TempDate.getDate()
    if (this.TempTime==undefined) {
      let tmp:Date=this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
      newHour=tmp.getHours()
      newMinute=tmp.getMinutes()
    }else{
      newHour=this.TempTime.hour
      newMinute=this.TempTime.minute
    }
    return (new Date(newYear,newMonth,newDay,newHour,newMinute)).getTime()
  }

  build() {
    Column(){
      Row(){
        DatePicker({
          start:new Date('2000-01-01'),
          end:new Date('2099-12-31'),
          selected:this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
        }).width('50%').onDateChange((Date)=>{this.TempDate=Date})
        TimePicker({
          selected:this.OldTime > 0 ? new Date(this.OldTime) : new Date(Date.now())
        }).width('50%').onChange((Time)=>{this.TempTime=Time})
      }
      Row({space:30}){
        Button(){
          Text('移除条件').fontSize(20)
        }.padding(10).width(120).backgroundColor('#E5E5E5').onClick(this.remove)
        Button(){
          Text('确定').fontSize(20)
        }.padding(10).width(120).backgroundColor('#AAFAFB').onClick(()=>{this.confirm(this.submit())})
      }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:20})
    }.padding(20).alignItems(HorizontalAlign.Start)
  }
}
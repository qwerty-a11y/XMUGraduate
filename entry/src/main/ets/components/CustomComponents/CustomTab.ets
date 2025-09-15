import List from '@ohos.util.List'

@Component
export struct CustomTab {
  @Prop TabList:Array<string>
  //TabList:Array<string>=[]
  @Link SelectIndex:number
  //SelectIndex:number=0
  @State AnimationTrigger:boolean=false

  /*
  aboutToAppear(): void {
    this.TabList=['学生','教师','超管']
  }
  */

  @Builder
  Tab(index:number,tab:string){
    Column(){
      Text(tab)
        .fontSize(14)
        .margin({
          top:15,
          bottom:10
        })
        Blank()
        .backgroundColor(this.SelectIndex==index?'#77F0EC':'#D1D1D1')
        .borderRadius(10)
        .width(40)
        .height(10)
    }
      .layoutWeight(1)
      .height('100%')
      .onClick(()=>{
        this.SelectIndex=index
        this.AnimationTrigger=!this.AnimationTrigger
      })
  }

  build(){
    Row(){
      ForEach(this.TabList,(tab:string,index:number)=>{
        this.Tab(index,tab)
      })
    }
      .alignItems(VerticalAlign.Center)
      .height(60)
  }
}
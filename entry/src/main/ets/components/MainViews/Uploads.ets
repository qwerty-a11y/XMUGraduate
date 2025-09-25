import {  NavigationBar, top, Category, ActivityCard,CategoryComponent,ActivityCardComponent} from '../../components/usu';
import router from '@ohos.router'; // 导入路由模块

@Component
export struct UploadsView{
  @State categories: Category[] = [
    {
      name: '类别1',
      cards: [
        {
          status: '审核失败，请重新提交',
          activityName: '活动名称1',
          publishTime: '发布时间1',
          score: '加0分',
          submitTime: '提交时间1',
        },
        {
          status: '审核成功',
          activityName: '活动名称2',
          publishTime: '发布时间2',
          score: '加*分',
          submitTime: '提交时间2',
        },
        {
          status: '审核成功',
          activityName: '活动名称3',
          publishTime: '发布时间3',
          score: '加*分',
          submitTime: '提交时间3',
        },
      ],
    },
    {
      name: '类别2',
      cards: [
        {
          status: '审核失败，请重新提交',
          activityName: '活动名称4',
          publishTime: '发布时间4',
          score: '加0分',
          submitTime: '提交时间4',
        },
        {
          status: '审核成功',
          activityName: '活动名称5',
          publishTime: '发布时间5',
          score: '加*分',
          submitTime: '提交时间5',
        },
        {
          status: '审核成功',
          activityName: '活动名称6',
          publishTime: '发布时间6',
          score: '加*分',
          submitTime: '提交时间6',
        },
      ],
    },
  ];
  @Link SelectedType:number;

  onPageShow(): void {
    const params = router.getParams() as Record<string, object>
    if(params){
      this.SelectedType=Number(params['targetType']) || 0;
    }
  }



  build() {
    Column(){
      top({onTypeSwitch:(type) => {
        this.SelectedType=type
      },currentPage:this.SelectedType})
        .width('100%')
        .height('20%')
        .backgroundColor('#FFFFFFFF')
        .position({
          x: 0,
          y: 0,  // 定位到父容器底部
          top: 0   // 关键偏移量设置
        })

      Scroll(){
        Column() {
          ForEach(this.categories, (category: Category) => {
            CategoryComponent({ category: category });
          });
        }
        .width(343)
        //.height('100%');
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .height('70%')
      .position({
        y:'20%',
        x:0
      })

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f4fafa');
  }

}
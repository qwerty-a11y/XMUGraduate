import router from '@ohos.router';
import { RecordEntry } from '../../../datatypes/Record';
import { TestData } from '../../../debug/TestData';
import { DateUtils } from '../../../utils';

@Entry
@Component
export struct teaUploadsView {
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @Prop image_uploadtime: ResourceStr = $r("app.media.RecordEntry_UploadTime");
  @Prop image_modifytime: ResourceStr = $r("app.media.RecordEntry_ModifyTime");
  @Prop image_filter: ResourceStr = $r("app.media.Filter");
  @State SearchText: string = '';
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']

  @State historyList: RecordEntry[] = TestData.RecordList;

  // 根据状态返回显示文本
  getStatusText(status: number): string {
    if (status == 2) return '已通过';
    if (status == 3) return '已驳回';
    return ''
  }

  // 根据状态返回文本颜色（修正：返回正确的颜色值格式）
  getStatusColor(status: number): ResourceColor {
    if (status == 2) return '#00B42A';
    if (status == 3) return '#F53F3F';
    return ''
  }

  build() {
    Column() {
      // 顶部搜索及历史记录标题区域
      Column() {
        Row() {
          Row() {
            Image(this.image_search)
              .width(24)
              .height(24)
              .margin({ left: 12 });
            TextInput({
              placeholder: 'Search',
              text: this.SearchText
            })
              .fontSize(16)
              .height(32)
              .backgroundColor('white')
              .placeholderColor('#999999')
              .margin({ left: 8 })
              .layoutWeight(1);
          }
          .backgroundColor('white')
          .borderRadius(20)
          .height(52)
          .width(280)
          .shadow({
            radius: 4,
            color: '#10000000',
            offsetX: 0,
          });

          Image(this.image_filter)
            .width(24)
            .margin({left:10})
        }

        Text('历史记录')
          .fontSize(14)
          .width('90%')
          .margin({ top: 10 });
      }
      .width('100%')
      .height('15%')
      .justifyContent(FlexAlign.Center);

      // 可滚动历史记录列表
      Scroll() {
        Column() {
          ForEach(this.historyList, (item: RecordEntry) => {
            Row(){
              Column(){
                Text(`${item.Title}`)
                  .fontSize(14)
                  .margin({ bottom: 4 });
                Text(`加分类别：${this.typeList[item.Type.valueOf()]}`)
                  .fontSize(14)
                  .margin({ bottom: 4 });
                // 修正：使用fontColor设置文本颜色，而非color
                Text(`状态：${this.getStatusText(item.ReviewStatus)}`)
                  .fontSize(14)
                  .fontColor(this.getStatusColor(item.ReviewStatus)) // 关键修复：color -> fontColor
                  .margin({ bottom: 4 });
              }
              .margin({left:10,right:10,top:10,bottom:10})
              .layoutWeight(1)

              Column(){
                Row() {
                  Image(this.image_uploadtime)
                    .width(12)
                  Text(`${DateUtils.ToString(item.UploadTime)}`)
                    .fontSize(14);
                }
                .margin({ bottom: 8 })

                Row() {
                  Image(this.image_modifytime)
                    .width(12)
                  Text(`${DateUtils.ToString(item.ModifyTime)}`)
                    .fontSize(14);
                }
              }
              .margin({left:10,right:10,top:10,bottom:10})
              .alignItems(HorizontalAlign.End)
            }
            .width('90%')
            .backgroundColor('white')
            .borderRadius(10)
            .margin({ bottom: 8 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Tea/Records' ,params:item});
            });
          });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);
      }
      .height('75%')
      .width('100%');
    }
    .width('100%')
    .height('100%');
  }
}
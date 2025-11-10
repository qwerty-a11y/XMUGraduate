import router from '@ohos.router';

interface HistoryItem {
  studentId: string;   // 学号
  submitTime: string;  // 提交时间
  category: string;    // 加分类别
  handleTime: string;  // 处理时间
}

@Component
export struct teaUploadsView {
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @Prop image_uploadtime: ResourceStr = $r("app.media.RecordEntry_UploadTime");
  @Prop image_modifytime: ResourceStr = $r("app.media.RecordEntry_ModifyTime");
  @Prop image_filter: ResourceStr = $r("app.media.Filter");
  @State SearchText: string = '';
  // 模拟更多历史记录数据，确保内容高度超过Scroll高度
  @State historyList: HistoryItem[] = [
    { studentId: '2022001001', submitTime: '2025-10-19 09:00', category: '学术论文', handleTime: '2025-10-19 10:30' },
    { studentId: '2022002005', submitTime: '2025-10-18 14:30', category: '竞赛获奖', handleTime: '2025-10-18 16:45' },
    { studentId: '2022003128', submitTime: '2025-10-17 10:15', category: '社会实践', handleTime: '2025-10-17 11:50' },
    { studentId: '2022001076', submitTime: '2025-10-16 08:20', category: '学术论文', handleTime: '2025-10-16 11:30' },
    { studentId: '2022004032', submitTime: '2025-10-15 15:40', category: '竞赛获奖', handleTime: '2025-10-15 17:20' },
    { studentId: '2022005015', submitTime: '2025-10-14 09:50', category: '学术论文', handleTime: '2025-10-14 11:20' },
    { studentId: '2022006028', submitTime: '2025-10-13 16:30', category: '社会实践', handleTime: '2025-10-13 18:00' },
    { studentId: '2022007042', submitTime: '2025-10-12 10:10', category: '竞赛获奖', handleTime: '2025-10-12 12:40' },
    { studentId: '2022008056', submitTime: '2025-10-11 14:20', category: '学术论文', handleTime: '2025-10-11 16:50' },
    { studentId: '2022009070', submitTime: '2025-10-10 08:40', category: '社会实践', handleTime: '2025-10-10 11:10' },
  ];

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

      // 可滚动历史记录列表，通过flexGrow占据剩余空间
      Scroll() {
        Column() {
          ForEach(this.historyList, (item: HistoryItem) => {
            Row(){
              Column(){
                Text(`学号：${item.studentId}`)
                     .fontSize(14)
                     .margin({ bottom: 4 });
                Text(`加分类别：${item.category}`)
                     .fontSize(14)
                     .margin({ bottom: 4 });
              }
              .margin({left:10,right:10,top:10,bottom:10})

              Column(){
                Row() {
                  Image(this.image_uploadtime)
                    .width(12)
                  Text(`${item.handleTime}`)
                    .fontSize(14);
                }

                Row() {
                  Image(this.image_modifytime)
                    .width(12)
                  Text(`${item.submitTime}`)
                    .fontSize(14)
                    .margin({ bottom: 4 });
                }
              }
              .margin({left:10,right:10,top:10,bottom:10})
            }
            .width('90%')
            .backgroundColor('white')
            .borderRadius(10)
            .margin({ bottom: 8 });
          });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);
      }
      .height('75%')
      .width('100%');
    }
    .width('100%')
    .height('100%'); // 最外层Column占满屏幕高度
  }
}
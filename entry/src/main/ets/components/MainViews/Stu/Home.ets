import { Poster, FeatureCard, CardItem } from './HomeComponents/TypeCard';
import router from '@ohos.router'; // 导入路由模块
import { BasicData } from '../../../service/Stu/BasicData';
import http from '@ohos.net.http';
import json from '@ohos.util.json';
import { StaticData,DynamicData} from '../../../constants';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { ApplicationStateChangeCallback } from '@kit.AbilityKit';
import { UploadsData } from '../../../service/Stu/UploadsData';

//import { AddItemDialog, AddItemDialogConfig } from '../../components/MainViews/StuUploadsComponents/addprojects';

interface empty {}
export interface BasicResponse {
  academic_expertise_score: number;
  academic_score: number;
  college: string;
  comprehensive_performance_score: number;
  created_at: string;
  failed_courses: number;
  gpa: number;
  gpa_ranking: number;
  id: string;
  major: string;
  name: string;
  ranking_dimension: string;
  school_id: string;
  total_comprehensive_score: number;
  total_courses: number;
  total_credits: number;
  updated_at: string;
  weighted_score: number;
  cet4: number;
  cet6: number;
  applications_score: number[];
}

@Component
export struct HomeView {
  @Prop image_world: ResourceStr = $r("app.media.world");
  @State GPA:number = BasicData.GPA
  @State score:number = BasicData.score
  @State estimated_score:number = BasicData.estimated_score
  @State CET:number[] = BasicData.CET
  @State applications:number[] = BasicData.applications
  // 控制首页导航项背景色
  @State homeNavBgColor: string = '#ffffffff';
  // 为数组添加明确的CardItem类型注解
  @State academicCards: Array<CardItem> = [
    {
      icon: $r('app.media.icon_1'),
      title: '学业竞赛',
      score: this.applications[0]
    },
    {
      icon: $r('app.media.icon_2'),
      title: '创新创业训练',
      score: this.applications[1]
    },
    {
      icon: $r('app.media.icon_3'),
      title: '科研成果',
      score: this.applications[2]
    },
  ];
  // 综合表现卡片数据
  @State performanceCards: Array<CardItem> = [
    {
      icon: $r('app.media.icon_4'),
      title: '荣誉称号',
      score: this.applications[3]
    },
    {
      icon: $r('app.media.icon_5'),
      title: '社会工作',
      score: this.applications[4]
    },
    {
      icon: $r('app.media.icon_6'),
      title: '志愿服务',
      score: this.applications[5]
    },
    {
      icon: $r('app.media.icon_7'),
      title: '国际组织学习',
      score: this.applications[6]
    },
    {
      icon: $r('app.media.icon_8'),
      title: '参军入伍',
      score: this.applications[7]
    },
    {
      icon: $r('app.media.icon_9'),
      title: '体育比赛',
      score: this.applications[8]
    }
  ];



  async refresh(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/score/student-performance/my_performance/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json', // 关键：添加这个头
            'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )
      let DataObj: BasicResponse | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}
        if (Response.responseCode == 200 && (Object.keys(DataObj).length>0)) {
          BasicData.GPA=(DataObj as BasicResponse).gpa
          BasicData.score=(DataObj as BasicResponse).total_comprehensive_score
          BasicData.CET=[(DataObj as BasicResponse).cet4,(DataObj as BasicResponse).cet6]
          BasicData.applications=(DataObj as BasicResponse).applications_score
          BasicData.departments=(DataObj as BasicResponse).college+(DataObj as BasicResponse).major
          this.GPA = BasicData.GPA
          this.score = BasicData.score
          this.estimated_score = BasicData.estimated_score
          this.CET = BasicData.CET
          this.applications = BasicData.applications
          this.academicCards[0].score=this.applications[0]
          this.academicCards[1].score=this.applications[1]
          this.academicCards[2].score=this.applications[2]
          this.performanceCards[0].score=this.applications[3]
          this.performanceCards[1].score=this.applications[4]
          this.performanceCards[2].score=this.applications[5]
          this.performanceCards[3].score=this.applications[6]
          this.performanceCards[4].score=this.applications[7]
          this.performanceCards[5].score=this.applications[8]
          this.academicCards=[...this.academicCards]
          this.performanceCards=[...this.performanceCards]
        } else if (Object && Object.keys(DataObj).includes('detail')){
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '登录失效，请重新登录',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          router.pushUrl({ url: 'pages/Login' })
        } else {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '刷新失败，请检查网络连接',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        // 使用 promptAction 显示提示
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000 // 弹窗显示时间（毫秒）
        });
        return;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
    }
  }

  aboutToAppear(): void {
    this.refresh()
    UploadsData.refresh()
  }

  @Prop image_setting: ResourceStr = $r("app.media.Settings"); // 设置图标
  build() {
    Column() {
      // 可滚动内容区域
      Scroll() {
        Column() {
          Row() {
            // 顶部“Hi~”文字
            Text('Hi~')
              .fontSize(32)
              .width(300)
              .margin({ top: 10, bottom: 5 });

            Image(this.image_setting)
              .width(24)
              .height(24)
              .backgroundImagePosition(Alignment.End)
              .margin({ right: 8 })
              .onClick(() => {
                // 路由跳转：跳转到"pages/setting"页面（需在config.json中配置该页面路径）
                router.pushUrl({ url: 'pages/Stu/Setting' });
              });
          }
          // 书本图片组件
          Poster()
            .width(340)
            .height(192)
            .margin({ bottom: 10 });

          // GPA 等信息区域
          Column() {
            Row() {
              Text('GPA')
                .fontSize(16);
              Text(`${this.GPA}/4.0`)
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 5 });

            Row() {
              Text('综测')
                .fontSize(16);
              Text(`${this.score}/100`)
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 5 });
/*
            Row() {
              Text('预计综测')
                .fontSize(16);
              Text('80/100')
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 5 });
*/
            Row() {
              Text('CET-4/CET-6')
                .fontSize(16);
              Text(`${this.CET[0]}/${this.CET[1]}`)
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 10 });
          }
          .width(340)
          .backgroundColor('#ffffff')
          .margin({bottom:15})
          .padding({ top: 5, bottom: 5 })
          .shadow({
            // 卡片阴影，增强立体感
            radius: 4,
            color: '#D9D9D9', // 浅灰色阴影
            offsetX: 2,
            offsetY: 4 // 阴影向下偏移2px
          });

          Row({space:10}) {
            Row() {
              Text('保研条例参考')
                .fontSize(18)
            }
            .width('47%')
            .height(32)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#84F2C3')
            .borderRadius(20)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Tea/Rules' });
            });

            Row() {
              Text("新添加分项")
                .fontSize(18)
              //.textAlign(TextAlign.Center)
            }
            //.alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('47%')
            .height(32)
            .backgroundColor('#84F2C3')
            .borderRadius(20)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Stu/AddProject' });
            });
          }

          // 学业专长标题
          Text('学业专长')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 10 })
            .width('100%')
            .padding({ left: 20 });

          // 学业专长横向滚动区域
          Scroll() {
            Row() {
              // 为ForEach的item添加明确的CardItem类型
              ForEach(this.academicCards, (item: CardItem) => {
                FeatureCard({ item: item });
              })
            }
            .width('auto')
            .padding({ bottom: 10 });
          }
          .width('100%')
          .height(224)
          .scrollable(ScrollDirection.Horizontal);

          // 综合表现标题
          Text('综合表现')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 10 })
            .width('100%')
            .padding({ left: 20 });

          // 综合表现横向滚动区域
          Scroll() {
            Row() {
              // 为ForEach的item添加明确的CardItem类型
              ForEach(this.performanceCards, (item: CardItem) => {
                FeatureCard({ item: item });
              })
            }
            .width('auto')
            .padding({ bottom: 10 })
            .backgroundImagePosition({ x: '0', y: 0 });
          }
          .width('100%')
          .height(224)
          .scrollable(ScrollDirection.Horizontal);

        }
        .width(340)
        .alignItems(HorizontalAlign.Center);
      }
      .scrollable(ScrollDirection.Vertical)
      .height('90%')
      .position({
        x: 0,
        y: 0,  // 定位到父容器底部
        bottom: 100   // 关键偏移量设置
      })
      .width('100%')
      .height('90%')
      .backgroundImageSize(ImageSize.Auto)
      .backgroundImagePosition(Alignment.Center);

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f4fafa')
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover);
  }
}

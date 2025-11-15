import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import {RecordEntry, RecordType} from '../../datatypes/Record'
import { request } from '@kit.BasicServicesKit';
import * as AddProjectComponents from '../../components/MainViews/Stu/AddProjectComponent'
import { inputConsumer } from '@kit.InputKit';

//import { FlexAlign, VerticalAlign, InputType } from '@ohos.util'; // 导入所需枚举类型

@Entry
@Component
struct AddOptionApplication {
  @Prop image_download: ResourceStr = $r('app.media.Download');
  @Prop image_false: ResourceStr = $r("app.media.false");
  @State isDialogShow: boolean = true;
  @State typeOptions: string[] = [
    '学业竞赛', '创新创业训练', '科研成果',
    '荣誉称号', '社会工作', '志愿服务',
    '国际组织学习', '参军入伍', '体育比赛'
  ];
  @State isTypeDropdownOpen: boolean = false;
  /*
  @State SelectedTypeIndex:number = 0;
  @State nameValue: string = '';
  @State descValue: string = '';
  @State scoreValue: string = '';
  @State fileUploaded: boolean = false;
  */
  @State tmpentry: RecordEntry = new RecordEntry(RecordType.Competition,'',0,0,'',Date.now())

  @Builder ApplicationType(){
    Column() {
      ForEach(this.typeOptions, (option: string, index: number) => { // 明确循环变量类型
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            this.isTypeDropdownOpen = false;
            this.tmpentry.Type = index
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder ExtraData(){
    if (this.tmpentry.Type.valueOf() == 0) {
      AddProjectComponents.Competition({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 1) {
      AddProjectComponents.Innovation({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 2) {
      AddProjectComponents.Research({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 3) {
      AddProjectComponents.Honor({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 4) {
      AddProjectComponents.SocialWork({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 5) {
      AddProjectComponents.Volunteer({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 6) {
      AddProjectComponents.International({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 7) {
      AddProjectComponents.Military({tmpentry:this.tmpentry})
    } else if (this.tmpentry.Type.valueOf() == 8) {
      AddProjectComponents.Sports({tmpentry:this.tmpentry})
    }
  }

  onSaveDraftClick(): void {
    promptAction.showToast({ message: '草稿已保存' });
  }

  onSubmitClick(): void {
    if (!this.tmpentry.Title) {
      promptAction.showToast({ message: '请输入名称' });
      return;
    }
    promptAction.showToast({ message: '提交成功' });
    this.isDialogShow = false;
  }

  onUploadFileClick(): void {
    promptAction.showToast({ message: '文件上传功能待实现' });
    //this.fileUploaded = true;
  }

  build() {
      Column() {
        if (this.isDialogShow) {
          Scroll() {
            Column() {
              Row() {
                Text('新增选项申请')
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                Blank()
                // Button({ type: ButtonType.Circle, stateEffect: true }) {
                //   Image(this.image_false)
                //     .width(20)
                //     .height(20)
                //     .backgroundColor('#ffffff')
                // }
                // .onClick(() => {
                //   this.isDialogShow = false;
                Image(this.image_false)
                  .width(20)
                  .height(20)
                  .backgroundColor('#ffffff')
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Stu/Main' });
                  });
              }
              .width('100%')
              .margin({ top: 20 })
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })

              // 类型选择行
              Row() {
                Text('类型')
                  .fontSize(16)
                  .margin({ right: 10 })
                Button(this.typeOptions[this.tmpentry.Type.valueOf()])
                  .backgroundColor('#fff6f5f5')
                  .fontColor('#000000')
                  .onClick(() => {
                    this.isTypeDropdownOpen = !this.isTypeDropdownOpen;
                  })
                  .bindMenu(this.isTypeDropdownOpen, this.ApplicationType)
                  .width(220)
                // Image(this.image_open)
                //   .width(16)
                //   .height(16)
                //   .margin({ left: 5 })
              }
              .width('100%')
              .padding({
                left: 30,
                right: 30,
                top: 10,
                bottom: 10
              })

              // 下拉选项列表
              //if (this.isTypeDropdownOpen) {

              //}

              // 名称输入行
              Row() {
                Text('名称')
                  .fontSize(16)
                  .margin({ right: 10 })
                TextInput({ placeholder: '请输入标题' })
                  .width(220)
                  .onChange((value: string) => { // 明确参数类型
                    this.tmpentry.Title = value;
                  })
              }
              .width('100%')
              .padding({
                left: 30,
                top: 10,
                bottom: 10
              })
              .margin({ top: 10 })

              // 详细描述输入行
              Column() {
                Text('详细描述')
                  .fontSize(16)
                  .width('100%')
                  .margin({ bottom: 10 })

                TextArea({ placeholder: '例如在其中扮演的角色' })
                  .width('100%')
                  .constraintSize({minHeight:80})
                  .onChange((value: string) => { // 明确参数类型
                    this.tmpentry.Description = value;
                  })
              }
              .width('100%')
              .padding({
                left: 30,
                right: 30,
                top: 10,
                bottom: 10
              })
              .margin({ top: 10 })

              // 申请分值输入行（修正inputType属性错误）
              // 申请分值输入行（正确设置输入类型）
              Row() {
                Text('申请分值')
                  .fontSize(16)
                  .margin({ right: 10 })
                TextInput({ placeholder: '请输入分值' }) // 构造函数仅传入placeholder
                  .width(100)
                  //.inputType(InputType.Number) // 通过链式调用设置输入类型
                  .onChange((value: string) => {
                    this.tmpentry.ApplyScore = Number(value);
                  })
                  .type(InputType.Number)
              }
              .width('100%')
              .padding({
                left: 30,
                right: 30,
                top: 10,
                bottom: 10
              })
              .margin({ top: 10 })
              .justifyContent(FlexAlign.SpaceBetween)

              this.ExtraData()

              // 证明文件上传行（修正对齐方式类型）
              Column() {
                Row() {
                  Text('证明文件')
                    .fontSize(16)
                    .margin({ right: 10, bottom: 10 })
                }
                .width('100%')

                Column() {
                  Row() {
                    Image(this.image_download)
                      .width(32)
                      .height(32)
                  }
                  .margin({ top: 10, bottom: 10 })
                  .width('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)


                  Text('请上传文件(支持png,pdf格式)')
                    .fontSize(14)// 使用正确的VerticalAlign
                    .margin({ bottom: 10 })
                }
                .backgroundColor('#ffeeeeee')
                .borderRadius(20)
                .width('100%')
                //.height(52)
                .onClick(() => this.onUploadFileClick())
              }
              .width('100%')
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })
              .margin({ top: 10 })

              // 按钮行
              Row() {
                Button('保存草稿')
                  .width(120)
                  .height(40)
                  .backgroundColor('#4DB6AC')
                  .fontColor(Color.White)
                  // .onClick(() => this.onSaveDraftClick())
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Stu/Main' });
                  });
                Blank()
                Button('提交')
                  .width(120)
                  .height(40)
                  .backgroundColor('#4DB6AC')
                  .fontColor(Color.White)
                  //.onClick(() => this.onSubmitClick())
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Stu/Main' });
                  });
              }
              .width('100%')
              .margin({ bottom: 20 })
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('90%')
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({
              radius: 8,
              color: '#00000014',
              offsetX: 0,
              offsetY: 4
            })
            .borderRadius(8)
          }
          .height('100%')
          .scrollable(ScrollDirection.Vertical)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
  }
}
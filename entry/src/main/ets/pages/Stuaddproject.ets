import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
//import { FlexAlign, VerticalAlign, InputType } from '@ohos.util'; // 导入所需枚举类型

@Entry
@Component
struct AddOptionApplication {
  @Prop image_open: ResourceStr = $r("app.media.open");
  @Prop image_download: ResourceStr = $r('app.media.Download');
  @Prop image_false: ResourceStr = $r("app.media.false");
  @State isDialogShow: boolean = true;
  @State selectedType: string = '选择申请类型';
  @State typeOptions: string[] = [
    '学业竞赛', '创新创业训练', '学术研究',
    '荣誉称号', '社会工作', '志愿服务',
    '国际组织学习', '参军入伍'
  ];
  @State isTypeDropdownOpen: boolean = false;
  @State nameValue: string = '';
  @State descValue: string = '';
  @State scoreValue: string = '';
  @State fileUploaded: boolean = false;

  // 明确参数和返回值类型
  handleTypeSelect(type: string): void {
    this.selectedType = type;
    this.isTypeDropdownOpen = false;
  }

  onSaveDraftClick(): void {
    promptAction.showToast({ message: '草稿已保存' });
  }

  onSubmitClick(): void {
    if (!this.selectedType || this.selectedType === '选择申请类型') {
      promptAction.showToast({ message: '请选择申请类型' });
      return;
    }
    if (!this.nameValue) {
      promptAction.showToast({ message: '请输入名称' });
      return;
    }
    promptAction.showToast({ message: '提交成功' });
    this.isDialogShow = false;
  }

  onUploadFileClick(): void {
    promptAction.showToast({ message: '文件上传功能待实现' });
    this.fileUploaded = true;
  }

  build() {
    Column() {

      if (this.isDialogShow) {
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
                router.pushUrl({ url: 'pages/StuMain' });
              });
          }
          .width('100%')
          .margin({top:20})
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
          // 类型选择行
          Row() {
            Text('类型')
              .fontSize(16)
              .margin({ right: 10 })
            Button(this.selectedType)
              .backgroundColor('#fff6f5f5')
              .fontColor('#ff8f8d8d')
              .onClick(() => {
                this.isTypeDropdownOpen = !this.isTypeDropdownOpen;
              })
              .width(220)
            // Image(this.image_open)
            //   .width(16)
            //   .height(16)
            //   .margin({ left: 5 })
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })

          // 下拉选项列表
          if (this.isTypeDropdownOpen) {
            Column() {
              ForEach(this.typeOptions, (option: string) => { // 明确循环变量类型
                Text(option)
                  .width('100%')
                  .padding(10)
                  .onClick(() => this.handleTypeSelect(option))
              })
            }
            .backgroundColor(Color.White)
            .border({ width: 1, color: '#EEEEEE', radius: 4 })
            .width('60%')
            .margin({ left: 60 })
          }

          // 名称输入行
          Row() {
            Text('名称')
              .fontSize(16)
              .margin({ right: 10 })
            TextInput({ placeholder: '请输入标题：（例如：）' })
              .width(200)
              .onChange((value: string) => { // 明确参数类型
                this.nameValue = value;
              })
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
          .margin({ top: 10 })

          // 详细描述输入行
          Column() {
            Text('详细描述')
              .fontSize(16)
              .width('100%')
              .margin({bottom:10})

            TextArea({ placeholder: '例如在其中扮演的角色' })
              .width('100%')
              .height(80)
              .onChange((value: string) => { // 明确参数类型
                this.descValue = value;
              })
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
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
                this.scoreValue = value;
              })
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
          .margin({ top: 10 })

          // 证明文件上传行（修正对齐方式类型）
          Column() {
            Row() {
              Text('证明文件')
                .fontSize(16)
                .margin({ right: 10 ,bottom:10})
            }
           .width('100%')
            Column(){
              Row() {
                Image(this.image_download)
                  .width(32)
                  .height(32)
              }
              .margin({top:10,bottom:10})
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)


              Text('请上传文件(支持png,pdf格式)')
                .fontSize(14)// 使用正确的VerticalAlign
                .margin({bottom:10})
            }
            .backgroundColor('#ffeeeeee')
            .borderRadius(20)
            .width('100%')
            //.height(52)
            .onClick(() => this.onUploadFileClick())
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
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
                router.pushUrl({ url: 'pages/StuMain' });
              });
            Blank()
            Button('提交')
              .width(120)
              .height(40)
              .backgroundColor('#4DB6AC')
              .fontColor(Color.White)
              //.onClick(() => this.onSubmitClick())
              .onClick(() => {
                router.pushUrl({ url: 'pages/StuMain' });
              });
          }
          .width('100%')
          .margin({bottom:20})
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('90%')
        .backgroundColor(Color.White)
        .borderRadius(12)
        .shadow({ radius: 8, color: '#00000014', offsetX: 0, offsetY: 4 })
        .position({ x: '5%', y: '5%' })
        .borderRadius(8)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
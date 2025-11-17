import { fileUri, picker } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import {FileSelectResult,PathInfo,DocumentSelectOptions,ImageSelectOptions} from '../datatypes/FilePicker'


class FilePickerManager {
  private static instance: FilePickerManager;

  // 私有构造函数，确保单例
  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): FilePickerManager {
    if (!FilePickerManager.instance) {
      FilePickerManager.instance = new FilePickerManager();
    }
    return FilePickerManager.instance;
  }

  /**
   * 选择文档文件
   * @param context UIAbilityContext
   * @param options 选择选项
   * @returns 文件选择结果
   */
  public static async selectDocuments(context: common.UIAbilityContext, options?: DocumentSelectOptions): Promise<FileSelectResult> {
    return new Promise(async (resolve, reject) => {
      try {
        const documentViewPicker = new picker.DocumentViewPicker(context);
        const documentSelectOptions = new picker.DocumentSelectOptions();

        // 设置选择数量
        if (options?.maxSelectNumber) {
          documentSelectOptions.maxSelectNumber = options.maxSelectNumber;
        }

        // 设置文件扩展名过滤
        if (options?.fileExtensions && options.fileExtensions.length > 0) {
          documentSelectOptions.fileSuffixFilters = options.fileExtensions;
        }

        const uris = await documentViewPicker.select(documentSelectOptions);

        console.info('Document selection successful, uris:' + JSON.stringify(uris));

        // 转换URI为路径和文件名
        const result = await FilePickerManager.processUris(uris);
        resolve(result);
      } catch (err) {
        console.error(`Document selection failed, code: ${(err as BusinessError).code}, message: ${(err as BusinessError).message}`);
        reject(err);
      }
    });
  }

  /**
   * 选择单个文档文件
   * @param context UIAbilityContext
   * @param options 选择选项
   * @returns 单个文件选择结果
   */
  public static async selectSingleDocument(context: common.UIAbilityContext, options?: DocumentSelectOptions): Promise<FileSelectResult> {
    const selectOptions: DocumentSelectOptions = {
      maxSelectNumber: 1
    };

    // 手动复制属性，避免使用展开运算符
    if (options) {
      if (options.fileExtensions) {
        selectOptions.fileExtensions = options.fileExtensions;
      }
    }

    return FilePickerManager.selectDocuments(context, selectOptions);
  }

  /**
   * 选择图片文件
   * @param context UIAbilityContext
   * @param options 选择选项
   * @returns 图片选择结果
   */
  public static async selectImages(context: common.UIAbilityContext, options?: ImageSelectOptions): Promise<FileSelectResult> {
    return new Promise(async (resolve, reject) => {
      try {
        const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();

        // 设置MIME类型
        photoSelectOptions.MIMEType = options?.mimeType || photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;

        // 设置选择数量
        photoSelectOptions.maxSelectNumber = options?.maxSelectNumber || 1;

        const photoPicker = new photoAccessHelper.PhotoViewPicker();
        const photoSelectResult = await photoPicker.select(photoSelectOptions);

        console.info('Image selection successful, result: ' + JSON.stringify(photoSelectResult));

        // 处理选择结果
        const processedResult = await FilePickerManager.processUris(photoSelectResult.photoUris);

        // 手动创建结果对象，避免使用展开运算符
        const result: FileSelectResult = {
          uris: processedResult.uris,
          paths: processedResult.paths,
          fileNames: processedResult.fileNames,
          isOriginalPhoto: photoSelectResult.isOriginalPhoto
        };

        resolve(result);
      } catch (err) {
        console.error(`Image selection failed with err: ${(err as BusinessError).code}, ${(err as BusinessError).message}`);
        reject(err);
      }
    });
  }

  /**
   * 选择单个图片文件
   * @param context UIAbilityContext
   * @param options 选择选项
   * @returns 单个图片选择结果
   */
  public static async selectSingleImage(context: common.UIAbilityContext, options?: ImageSelectOptions): Promise<FileSelectResult> {
    const selectOptions: ImageSelectOptions = {
      maxSelectNumber: 1
    };

    // 手动复制属性，避免使用展开运算符
    if (options) {
      if (options.mimeType) {
        selectOptions.mimeType = options.mimeType;
      }
      if (options.includeOriginal !== undefined) {
        selectOptions.includeOriginal = options.includeOriginal;
      }
    }

    return FilePickerManager.selectImages(context, selectOptions);
  }

  /**
   * 处理URI数组，转换为路径和文件名
   * @param uris URI数组
   * @returns 处理后的结果
   */
  private static async processUris(uris: string[]): Promise<FileSelectResult> {
    const paths: string[] = [];
    const fileNames: string[] = [];

    for (const uri of uris) {
      try {
        const fileUriObject = new fileUri.FileUri(uri);
        const path = fileUriObject.path;
        paths.push(path);

        // 提取文件名
        const lastSlashIndex = path.lastIndexOf('/');
        const fileName = lastSlashIndex !== -1 ? path.substring(lastSlashIndex + 1) : path;
        fileNames.push(fileName);
      } catch (err) {
        console.error(`Failed to process URI: ${uri}, error: ${JSON.stringify(err)}`);
        paths.push('');
        fileNames.push('');
      }
    }

    return {
      uris,
      paths,
      fileNames
    };
  }

  /**
   * 从URI获取文件路径信息
   * @param uri 文件URI
   * @returns 路径信息
   */
  public static getPathInfo(uri: string): PathInfo {
    try {
      const fileUriObject = new fileUri.FileUri(uri);
      const fullPath = fileUriObject.path;
      const lastSlashIndex = fullPath.lastIndexOf('/');

      const directory = lastSlashIndex !== -1 ? fullPath.substring(0, lastSlashIndex + 1) : '';
      const fileName = lastSlashIndex !== -1 ? fullPath.substring(lastSlashIndex + 1) : fullPath;

      return {
        fullPath,
        directory,
        fileName
      };
    } catch (err) {
      console.error(`Failed to get path info from URI: ${uri}, error: ${JSON.stringify(err)}`);
      return {
        fullPath: '',
        directory: '',
        fileName: ''
      };
    }
  }

  /**
   * 显示文件信息提示
   * @param result 文件选择结果
   */
  public static showFileInfoToast(result: FileSelectResult): void {
    if (result.uris.length === 0) {
      promptAction.showToast({
        message: '未选择任何文件'
      });
      return;
    }

    if (result.uris.length === 1) {
      const pathInfo = FilePickerManager.getPathInfo(result.uris[0]);
      promptAction.showToast({
        message: `已选择文件: ${pathInfo.fileName}\n路径: ${pathInfo.directory}`
      });
    } else {
      promptAction.showToast({
        message: `已选择 ${result.uris.length} 个文件`
      });
    }
  }

  /**
   * 创建文档选择选项（辅助方法）
   */
  public static createDocumentOptions(maxSelectNumber: number = 1, fileExtensions: string[] = []): DocumentSelectOptions {
    return {
      maxSelectNumber,
      fileExtensions
    };
  }

  /**
   * 创建图片选择选项（辅助方法）
   */
  public static createImageOptions(maxSelectNumber: number = 1, includeOriginal: boolean = false): ImageSelectOptions {
    return {
      maxSelectNumber,
      includeOriginal,
      mimeType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    };
  }

  /**
   * 创建视频选择选项（辅助方法）
   */
  public static createVideoOptions(maxSelectNumber: number = 1): ImageSelectOptions {
    return {
      maxSelectNumber,
      mimeType: photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE
    };
  }

  /**
   * 创建图片和视频选择选项（辅助方法）
   */
  public static createImageAndVideoOptions(maxSelectNumber: number = 1): ImageSelectOptions {
    return {
      maxSelectNumber,
      mimeType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
  }
}

export default FilePickerManager;
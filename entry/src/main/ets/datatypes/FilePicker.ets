import { photoAccessHelper } from '@kit.MediaLibraryKit';

// 文件选择结果接口
export interface FileSelectResult {
  uris: string[];
  paths?: string[];
  fileNames?: string[];
  isOriginalPhoto?: boolean; // 仅图片选择有效
}

// 文档选择选项接口
export interface DocumentSelectOptions {
  maxSelectNumber?: number;
  fileExtensions?: string[];
}

// 图片选择选项接口
export interface ImageSelectOptions {
  maxSelectNumber?: number;
  mimeType?: photoAccessHelper.PhotoViewMIMETypes;
  includeOriginal?: boolean;
}

export interface PathInfo {
  fullPath: string;
  directory: string;
  fileName: string;
}
# incron 所支援的檔案狀態如下：
 - IN_ACCESS  檔案被讀取*
 - IN_ATTRIB  Metadata 被修改* (permissions, timestamps, extended attributes, etc.)
 - IN_CLOSE_WRITE  檔案被開啟，有寫入後關閉檔案*
 - IN_CLOSE_NOWRITE  檔案被開啟，無任何寫入後關閉檔案*
 - IN_CREATE  監測目錄下有檔案或目錄被新增*
 - IN_DELETE  監測目錄下有檔案或目錄被刪除*
 - IN_DELETE_SELF  監測的檔案或目錄被刪除
 - IN_MODIFY  檔案被修改*
 - IN_MOVE_SELF  監測的檔案或目錄被移動
 - IN_MOVED_FROM  監測目錄下有檔案被移出*
 - IN_MOVED_TO  監測目錄下有檔案移入*
 - IN_OPEN  檔案被打開*
 - IN_ALL_EVENTS  所有的狀態
 - IN_NO_LOOP  用來避免無限迴圈

# incron 可以使用變數
 - "$$"  錢字號(跳脫)
 - $@  監測的目錄
 - $#  觸發的檔案名稱
 - $%  觸發的狀態(文字)
 - $&  觸發的狀態(數字)
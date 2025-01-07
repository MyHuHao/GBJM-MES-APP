import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesapp/Model/Dictionary/dictionary_model.dart';
import 'package:mesapp/Preference/userinfo_preference.dart';
import 'package:mesapp/Route/app_routes.dart';
import 'package:mesapp/Service/MaterialReceivingLine/material_receiving_line_service.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:mesapp/Widgets/adaptive_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mesapp/Model/MaterialReceivingLine/material_receiving_line_model.dart';

class MaterialReceivingLinePage extends StatefulWidget {
  const MaterialReceivingLinePage({super.key});

  @override
  MaterialReceivingLinePageState createState() => MaterialReceivingLinePageState();
}

class MaterialReceivingLinePageState extends State<MaterialReceivingLinePage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _valueKey = GlobalKey<FormFieldState>();
  final _valueFocusNode = FocusNode();
  final _scrollController = ScrollController();

  String accId = "";
  final List<TableData> _items = [];
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 获取当前登录账户信息
    final userInfoPreference = UserInfoPreference();
    userInfoPreference.getJobNumber().then((String value) {
      // 在这里处理返回的布尔值
      if (value.isNotEmpty) {
        accId = value;
      }
    });
    _loadMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _valueController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_valueFocusNode.hasFocus) {
        _valueFocusNode.requestFocus();
      }
    } else {
      if (_valueFocusNode.hasFocus) {
        _valueFocusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        // 禁用普通的返回行为
        canPop: false,
        // 自定义返回键行为
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          _returnPage();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                _returnPage();
              },
            ),
            title: const Text(
              '转料到站-线检',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            elevation: 0.5,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildTextFormField(),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _buildListCard(), // 用 Expanded 包裹列表
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTextFormField() {
    return Row(
      children: [
        // 扫码枪文本框
        Expanded(
          child: TextFormField(
            key: _valueKey,
            focusNode: _valueFocusNode,
            controller: _valueController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0), // 聚焦时的边框
              ),
              hintText: '请输入流程卡/线检号',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.qr_code, color: Colors.grey), // 左侧图标
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '流程卡/线检号不能为空';
              }
              return null;
            },
            autofocus: true, // 页面加载时自动获取焦点
            readOnly: false, // 可以输入，但是不能弹出键盘
            keyboardType: TextInputType.number, // 禁止弹出键盘
            onFieldSubmitted: (value) {
              // 监听到回车事件后触发的逻辑
              // 你可以在这里处理扫码后完成的操作
              _addMaterialReceivingLine(value);
            },
          ),
        ),
        const SizedBox(width: 8.0), // 按钮与文本框间距
        IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.blue),
          onPressed: () async {
            // 跳转到扫码页面
            try {
              // 等待扫码页面返回结果
              String? result = await NavigationService().navigateTo(AppRoutes.qrCodeScanner);
              if (result != null && result.isNotEmpty) {
                // 添加短暂延迟，确保页面返回完全完成
                await Future.delayed(const Duration(milliseconds: 300));
                if (context.mounted) {
                  _valueController.text = result;
                  _addMaterialReceivingLine(result);
                }
              }
            } catch (e) {
              Fluttertoast.showToast(msg: '操作失败：$e');
            }
          },
        ),
      ],
    );
  }

  Widget _buildListCard() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.blue,
      backgroundColor: Colors.white,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior(), // 隐藏滚动条的行为
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _items.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _items.length) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                shadowColor: Colors.grey.withOpacity(0.2),
                elevation: 2,
                child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Text(
                      "流程卡号: ${_items[index].runCard}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "创建时间: ${_items[index].createdDd}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    onTap: () {
                      // 点击卡片时的逻辑
                      // 你可以在这里处理卡片的点击事件
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // 允许内容高度超出弹窗大小
                        isDismissible: false, // 设置为 false 后点击遮罩不会关闭弹窗
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16), // 圆角边框
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              height: 500, // 弹窗高度
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '详细信息',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        _buildLabel('工厂', _items[index].plant),
                                        _buildLabel('流程卡号', _items[index].runCard),
                                        _buildLabel('工序', _items[index].operation),
                                        _buildLabel('数量', _items[index].qty.toString()),
                                        _buildLabel('计件单', _items[index].ticketSn),
                                        _buildLabel('线检单', _items[index].mtSn),
                                        _buildLabel('创建人', _items[index].createdUId),
                                        _buildLabel('创建时间', _items[index].createdDd),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              );
            } else if (_isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || (_page == 0 && _items.isNotEmpty)) return;
    setState(() {
      _isLoading = true;
    });

    try {
      _getTableData();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 0;
      _items.clear();
    });

    try {
      _loadMoreData();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getTableData() async {
    setState(() {
      _isLoading = true;
    });

    TableDataPara para = TableDataPara(
      plant: "DG",
      runCard: "",
      page: _page + 1,
      pageSize: 15,
    );

    try {
      final res = await context.read<MaterialReceivingLineService>().getTableData(para);
      if (res.msgCode != '0') {
        EasyLoading.showToast('获取失败：${res.msg}');
      } else {
        setState(() {
          _page++;
          _items.addAll(res.data?.records ?? []);
        });
      }
    } catch (error) {
      EasyLoading.showToast('发生错误：$error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addMaterialReceivingLine(String value) async {
    if (_formKey.currentState?.validate() ?? false) {
      EasyLoading.show(status: '到料中...');
      try {
        List<String> strList = value.split(';');
        Map<String, dynamic> form = {};
        if (strList.length == 12) {
          form = {
            'PLANT': 'DG',
            'QR_CODE': value,
            'QR_TYPE': 1,
            'INSPECTOR': accId,
          };
        } else if (strList.length == 14) {
          form = {
            'FW_COUNT': strList[1],
            'RUN_CARD': strList[2],
            'QTY': strList[3],
            'TICKET_SN': strList[7],
            'OPERATION': strList[12],
            'PLANT': 'DG',
            'INSPECTOR': accId,
            'QR_TYPE': 2,
          };
        } else {
          EasyLoading.dismiss();
          if (context.mounted) {
            bool result = await DialogUtil.showOkConfirmDialog('提示', "数据错误，请检查二维码");
            if (result == true) {
              _valueController.clear();
              if (!_valueFocusNode.hasFocus) {
                _valueFocusNode.requestFocus();
              }
            }
          }
          return;
        }
        MaterialReceivingLineAddResult res = await context.read<MaterialReceivingLineService>().addMaterialReceivingLine(form);
        EasyLoading.dismiss();
        if (res.code != 201) {
          String msg = materialReceivingEnum[res.code] ?? "识别失败,请检查流程卡号是否正确";
          if (msg.isNotEmpty) {
            // 添加短暂延迟，确保页面返回完全完成
            await Future.delayed(const Duration(milliseconds: 200));
            if (context.mounted) {
              bool result = await DialogUtil.showOkConfirmDialog('提示', msg);
              if (result == true) {
                _valueController.clear();
                if (!_valueFocusNode.hasFocus) {
                  _valueFocusNode.requestFocus();
                }
              }
            }
          }
        } else {
          EasyLoading.showToast('到料成功');
          _valueController.clear();
          if (!_valueFocusNode.hasFocus) {
            _valueFocusNode.requestFocus();
          }
        }
      } catch (error) {
        EasyLoading.dismiss();
        EasyLoading.showError('操作失败，请重试');
      } finally {
        // 在 res 处理完成之后统一调用刷新方法
        await _onRefresh();
      }
    }
  }

  void _returnPage() {
    NavigationService().goBack();
  }

  Widget _buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label：',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

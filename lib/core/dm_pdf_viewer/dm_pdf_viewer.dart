import 'dart:async';

import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:dvarmalchus_flutter/core/dm_pdf_viewer/pdfviewer_cubit.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DMPdfViewer extends StatefulWidget {
  const DMPdfViewer(
      {Key? key,
      required this.pdfPath,
      required this.localPdfPath,
      required this.title})
      : super(key: key);
  final String pdfPath;
  final String localPdfPath;
  final String title;
  @override
  State<DMPdfViewer> createState() => _DMPdfViewerState();
}

class _DMPdfViewerState extends State<DMPdfViewer> {
  final bool _loadError = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  @override
  void initState() {
    // locator.get<DMPdfViewerCubit>().initPdf(widget.pdfPath);
    locator.get<DMPdfViewerCubit>().initPdfLocal(widget.localPdfPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: DMColors.primaryColor,
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            )),
        splashColor: DMColors.primaryColor,
        primarySwatch: DMColors.primaryColor,
        textSelectionTheme: TextSelectionTheme.of(context)
            .copyWith(cursorColor: DMColors.primaryColor),
        tabBarTheme: TabBarThemeData(
          unselectedLabelColor: Colors.grey[700],
          labelColor: DMColors.primaryColor,
          labelStyle: const TextStyle(color: Colors.white), // color for text
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: DMColors.primaryColor),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return DMColors.primaryColor; // color when selected
              }
              return Colors.white; // default color when not selected
            },
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
          title: BlocBuilder<DMPdfViewerCubit, GotitPdfViewerState>(
            bloc: locator.get(),
            builder: (context, state) {
              var title = widget.title;
              if (state is GotitPdfViewerPageChange) {
                title += ' ${(state.page + 1)}/${state.total}';
              }
              return Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: BlocBuilder<DMPdfViewerCubit, GotitPdfViewerState>(
              bloc: locator.get(),
              buildWhen: (previous, current) =>
                  current is GotitPdfViewerPdfLoaded ||
                  current is GotitPdfViewerError,
              builder: (context, state) {
                if (state is GotitPdfViewerPdfLoaded) {
                  return _buildPDFFile(widget.localPdfPath);
                } else if (state is GotitPdfViewerError) {
                  return Text(state.error);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPDFFile(String pdfPath) {
    if (_loadError) {
      return TextButton(
          onPressed: () {},
          child: const Text('Something went wrong please try again later'));
    }
    return PDFView(
      key: UniqueKey(),
      filePath: pdfPath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: false,
      defaultPage: 0,
      backgroundColor: Colors.grey,
      onRender: (pages) {},
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) async {
        // pdfViewController.setPage(0);

        // _controller.complete(pdfViewController);
        // setState(() {});
      },
      onPageChanged: (page, total) {
        locator.get<DMPdfViewerCubit>().updateCurrentPage(page, total);
      },
    );
  }
}

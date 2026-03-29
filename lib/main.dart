import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const RahaReelsApp());
}

class RahaReelsApp extends StatelessWidget {
  const RahaReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAHA REELS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5A1F),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const SplashScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════
// SPLASH SCREEN — Modern animated Raha Reels branding
// ═══════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.4)),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.4, 0.8)),
    );
    
    _logoController.forward();
    _fadeController.repeat(period: const Duration(seconds: 2));
    
    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainWebView(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1A0800),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Icon
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF5A1F),
                              Color(0xFFFF8A00),
                              Color(0xFFFF4500),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5A1F).withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'R',
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // App Name
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFFFF5A1F),
                                Color(0xFFFF8A00),
                                Color(0xFFFFD700),
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'RAHA REELS',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Streaming & Earn',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.5),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Loading indicator
                  Opacity(
                    opacity: _textOpacity.value,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFFF5A1F).withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// MAIN WEBVIEW — Loads rahareels.com with Google Auth
// ═══════════════════════════════════════════════════
class MainWebView extends StatefulWidget {
  const MainWebView({super.key});

  @override
  State<MainWebView> createState() => _MainWebViewState();
}

class _MainWebViewState extends State<MainWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  // Domains allowed inside WebView
  static const _allowedHosts = [
    'rahareels.com',
    'www.rahareels.com',
  ];

  // Google OAuth/GSI domains → open in system browser (Chrome Custom Tabs)
  // This ensures Google account picker works natively with saved accounts
  static const _googleAuthHosts = [
    'accounts.google.com',
    'myaccount.google.com',
    'googleapis.com',
    'gstatic.com',
    'google.com',
  ];

  bool _isAllowedHost(String host) {
    return _allowedHosts.any((h) => host.contains(h));
  }

  bool _isGoogleAuthUrl(String url) {
    final uri = Uri.parse(url);
    return _googleAuthHosts.any((h) => uri.host.contains(h));
  }

  @override
  void initState() {
    super.initState();
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0A0A))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress > 80 && _isLoading) {
              setState(() => _isLoading = false);
            }
          },
          onPageStarted: (String url) {
            // Don't show loading for Google redirects back
            if (!_isGoogleAuthUrl(url)) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // Inject video DRM protection
            _controller.runJavaScript('''
              document.querySelectorAll('video').forEach(v => {
                v.addEventListener('contextmenu', e => e.preventDefault());
                v.setAttribute('controlsList', 'nodownload noremoteplayback');
                v.setAttribute('disablePictureInPicture', '');
              });
              new MutationObserver(mutations => {
                mutations.forEach(m => m.addedNodes.forEach(n => {
                  if (n.tagName === 'VIDEO' || (n.querySelectorAll && n.querySelectorAll('video').length)) {
                    (n.tagName === 'VIDEO' ? [n] : n.querySelectorAll('video')).forEach(v => {
                      v.addEventListener('contextmenu', e => e.preventDefault());
                      v.setAttribute('controlsList', 'nodownload noremoteplayback');
                    });
                  }
                }));
              }).observe(document.body, { childList: true, subtree: true });
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            if (error.errorCode != -1) {
              setState(() => _hasError = true);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);
            
            // Allow rahareels.com inside WebView
            if (uri.host.isEmpty || _isAllowedHost(uri.host)) {
              return NavigationDecision.navigate;
            }
            
            // Google Auth URLs → open in system browser (Chrome Custom Tabs)
            // This gives native Google account picker with saved credentials
            if (_isGoogleAuthUrl(request.url)) {
              _launchInBrowser(request.url);
              return NavigationDecision.prevent;
            }
            
            // Block all other external URLs
            return NavigationDecision.prevent;
          },
        ),
      )
      // NO custom user agent — use default browser UA so Google GSI works
      ..loadRequest(Uri.parse('https://rahareels.com'));
  }

  /// Open URL in system browser (Chrome Custom Tabs on Android, Safari on iOS)
  /// This ensures Google Sign-In works with native account picker
  Future<void> _launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    if (!mounted) return false;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari RAHA REELS?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Yakin ingin keluar dari aplikasi?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFFFF5A1F))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Keluar', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Stack(
            children: [
              // WebView
              WebViewWidget(controller: _controller),
              
              // Loading overlay
              if (_isLoading)
                Container(
                  color: const Color(0xFF0A0A0A),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF5A1F), Color(0xFFFF8A00)],
                            ),
                          ),
                          child: const Center(
                            child: Text('R', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFFFF5A1F).withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Error screen
              if (_hasError && !_isLoading)
                Container(
                  color: const Color(0xFF0A0A0A),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada koneksi internet',
                          style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Periksa koneksi internet kamu dan coba lagi',
                          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isLoading = true;
                            });
                            _controller.loadRequest(Uri.parse('https://rahareels.com'));
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A1F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

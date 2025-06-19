import 'package:flutter/material.dart';


const Color harmonicCore = Color(
  0xFF1E40AF,
); // Azul profundo (220°) - Ancla principal
const Color harmonicWarm = Color(
  0xFFF97316,
); // Coral anaranjado (40°) - Calor complementario
const Color harmonicCool = Color(
  0xFF059669,
); // Verde esmeralda (160°) - Frescura natural
const Color harmonicAnalogCool = Color(
  0xFF7C3AED,
); // Violeta índigo (260°) - Elegancia profunda
const Color harmonicAnalogWarm = Color(
  0xFF0891B2,
); // Azul cielo (180°) - Luminosidad equilibrada

// =======================================================================
// PALETA DE NEUTRALES HARMÓNICOS
// =======================================================================

const Color harmonicNeutralDeep = Color(
  0xFF0F172A,
); // Marino profundo (base oscura)
const Color harmonicNeutralMid = Color(0xFF475569); // Gris slate (punto medio)
const Color harmonicNeutralSoft = Color(0xFF94A3B8); // Gris suave (transición)
const Color harmonicNeutralLight = Color(
  0xFFF8FAFC,
); // Perla luminosa (base clara)

// =======================================================================
// COLORES SEMÁNTICOS CON HARMONY EQUILIBRADA
// =======================================================================

const Color harmonicSuccess = harmonicCool; // Verde esmeralda - éxito natural
const Color harmonicWarning = harmonicWarm; // Coral - advertencia cálida
const Color harmonicError = Color(0xFFDC2626); // Rojo coral - error equilibrado
const Color harmonicInfo = harmonicAnalogWarm; // Azul cielo - información clara

// =======================================================================
// TEMA OSCURO MODERNO CON HARMONY CROMÁTICA
// =======================================================================

const Color modernDarkBackground = Color(0xFF0A0F1C); // Negro azulado profundo
const Color modernDarkSurface = Color(0xFF1E293B); // Superficie slate oscura
const Color modernDarkElevated = Color(0xFF334155); // Elevación sutil
const Color modernDarkPrimary = harmonicCore; // Azul profundo principal
const Color modernDarkSecondary = harmonicAnalogCool; // Violeta elegante
const Color modernDarkAccent = harmonicWarm; // Coral vibrante para acentos
const Color modernDarkTertiary =
    harmonicAnalogWarm; // Azul cielo para variaciones

// Texto con hierarchy equilibrada
const Color modernDarkText = Color(0xFFF1F5F9); // Texto principal luminoso
const Color modernDarkSecondaryText = Color(
  0xFFCBD5E1,
); // Texto secundario suave
const Color modernDarkMutedText = Color(0xFF94A3B8); // Texto silenciado

// Estados semánticos equilibrados
const Color modernDarkSuccess = harmonicSuccess; // Verde esmeralda
const Color modernDarkWarning = harmonicWarning; // Coral anaranjado
const Color modernDarkError = harmonicError; // Rojo coral
const Color modernDarkInfo = harmonicInfo; // Azul cielo

// =======================================================================
// TEMA CLARO MODERNO CON HARMONY CROMÁTICA
// =======================================================================

const Color modernLightBackground = Color(0xFFFBFCFE); // Blanco perla cálido
const Color modernLightSurface = Color(0xFFFFFFFF); // Superficie pura
const Color modernLightElevated = Color(0xFFF1F5F9); // Elevación sutil
const Color modernLightPrimary = harmonicCore; // Azul profundo principal
const Color modernLightSecondary = harmonicAnalogWarm; // Azul cielo equilibrado
const Color modernLightAccent = harmonicWarm; // Coral para acentos
const Color modernLightTertiary =
    harmonicAnalogCool; // Violeta para variaciones

// Texto con contraste óptimo
const Color modernLightText = Color(0xFF1E293B); // Texto principal profundo
const Color modernLightSecondaryText = Color(
  0xFF64748B,
); // Texto secundario equilibrado
const Color modernLightMutedText = Color(0xFF94A3B8); // Texto silenciado

// Estados semánticos con contraste adecuado
const Color modernLightSuccess = Color(0xFF047857); // Verde esmeralda oscuro
const Color modernLightWarning = Color(0xFFEA580C); // Coral más oscuro
const Color modernLightError = Color(0xFFB91C1C); // Rojo profundo
const Color modernLightInfo = Color(0xFF0E7490); // Azul cielo oscuro

// =======================================================================
// GRADIENTES HARMÓNICOS MODERNOS
// =======================================================================

final LinearGradient darkGradientBackground = LinearGradient(
  colors: [harmonicNeutralDeep, Color(0xFF1E293B).withOpacity(0.95)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient darkCardGradient = LinearGradient(
  colors: [modernDarkSurface, modernDarkTertiary.withOpacity(0.05)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient lightGradientBackground = LinearGradient(
  colors: [modernLightBackground, harmonicNeutralLight],
  begin: Alignment.topLeft,
  end: Alignment.centerRight,
);

final LinearGradient lightCardGradient = LinearGradient(
  colors: [modernLightSurface, modernLightElevated],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Gradientes de botones con harmony cromática
final LinearGradient primaryGradientDark = LinearGradient(
  colors: [modernDarkPrimary, modernDarkSecondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient primaryGradientLight = LinearGradient(
  colors: [modernLightPrimary, modernLightSecondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient accentGradientDark = LinearGradient(
  colors: [modernDarkAccent, modernDarkTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient accentGradientLight = LinearGradient(
  colors: [modernLightAccent, modernLightTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// =======================================================================
// COLORES DE NOTIFICACIONES Y RETROALIMENTACIÓN
// =======================================================================

const Color darkNotificationBackground = modernDarkAccent;
const Color darkNotificationText = Colors.white;
const Color darkNotificationSuccess = modernDarkSuccess;
const Color darkNotificationWarning = modernDarkWarning;
const Color darkNotificationError = modernDarkError;
const Color darkNotificationInfo = modernDarkInfo;

const Color lightNotificationBackground = modernLightAccent;
const Color lightNotificationText = Colors.white;
const Color lightNotificationSuccess = modernLightSuccess;
const Color lightNotificationWarning = modernLightWarning;
const Color lightNotificationError = modernLightError;
const Color lightNotificationInfo = modernLightInfo;

// =======================================================================
// COLORES DE INTERACCIÓN Y ESTADOS
// =======================================================================

final Color darkHoverOverlay = modernDarkPrimary.withOpacity(0.08);
final Color lightHoverOverlay = modernLightPrimary.withOpacity(0.06);

final Color darkFocusColor = modernDarkSecondary;
final Color lightFocusColor = modernLightPrimary;

final Color darkPressedOverlay = modernDarkPrimary.withOpacity(0.12);
final Color lightPressedOverlay = modernLightPrimary.withOpacity(0.10);

final Color darkDisabledColor = modernDarkSecondaryText.withOpacity(0.4);
final Color lightDisabledColor = modernLightSecondaryText.withOpacity(0.5);

// =======================================================================
// COLORES SEMÁNTICOS ESPECÍFICOS
// =======================================================================

const Color semanticSuccessDark = modernDarkSuccess;
const Color semanticSuccessLight = modernLightSuccess;
const Color semanticWarningDark = modernDarkWarning;
const Color semanticWarningLight = modernLightWarning;
const Color semanticErrorDark = modernDarkError;
const Color semanticErrorLight = modernLightError;
const Color semanticInfoDark = modernDarkInfo;
const Color semanticInfoLight = modernLightInfo;

// =======================================================================
// COLORES FAVORITOS REBALANCEADOS (HARMÓNICOS)
// =======================================================================

// Deep Sky Blue rebalanceado para harmony cromática
const Color rebalancedDeepSkyBlue = harmonicAnalogWarm; // Azul cielo harmónico

// Blue Violet rebalanceado con nueva saturación equilibrada
const Color rebalancedBlueViolet = harmonicAnalogCool; // Violeta harmónico

// Hot Pink rebalanceado como coral armónico
const Color rebalancedHotPink = harmonicWarm; // Coral harmónico

// Gold rebalanceado como ámbar equilibrado
const Color rebalancedGold = Color(0xFFF59E0B); // Ámbar harmónico

// Referencias favoritas para compatibilidad
const Color favDeepSkyBlue = rebalancedDeepSkyBlue;
const Color favBlueViolet = rebalancedBlueViolet;
const Color favHotPink = rebalancedHotPink;
const Color favGold = rebalancedGold;

// =======================================================================
// VERSIONES HARMÓNICAS DE LOS COLORES FAVORITOS
// =======================================================================

// Versiones claras y oscuras para mejor adaptabilidad
const Color harmonicPrimaryLight = Color(0xFF818CF8); // Índigo más claro
const Color harmonicPrimaryDark = Color(0xFF4338CA); // Índigo más oscuro
const Color harmonicSecondaryLight = Color(0xFF22D3EE); // Cyan más claro
const Color harmonicSecondaryDark = Color(0xFF0E7490); // Cyan más oscuro
const Color harmonicTertiaryLight = Color(0xFF34D399); // Esmeralda más claro
const Color harmonicTertiaryDark = Color(0xFF047857); // Esmeralda más oscuro
const Color harmonicAccentLight = Color(0xFFFBBF24); // Ámbar más claro
const Color harmonicAccentDark = Color(0xFFD97706); // Ámbar más oscuro

// =======================================================================
// GRADIENTES HERO Y DESTACADOS
// =======================================================================

final LinearGradient heroGradientDark = LinearGradient(
  colors: [modernDarkPrimary, modernDarkSecondary, modernDarkTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient heroGradientLight = LinearGradient(
  colors: [modernLightPrimary, modernLightSecondary, modernLightTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// =======================================================================
// CONFIGURACIÓN ESPECÍFICA DE LA APP
// =======================================================================

const Color appPrimaryBlue = harmonicCore;
const Color appLightBlue = Color(0xFF60A5FA);
const Color appDarkBlue = Color(0xFF2563EB);

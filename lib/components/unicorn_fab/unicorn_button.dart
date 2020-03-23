import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class UnicornOrientation {
  static const HORIZONTAL = 0;
  static const VERTICAL = 1;
}

class UnicornButton extends FloatingActionButton {
  final FloatingActionButton currentButton;
  final String labelText;
  final double labelFontSize;
  final Color labelColor;
  final Color labelBackgroundColor;
  final Color labelShadowColor;
  final bool labelHasShadow;
  final bool hasLabel;

  UnicornButton(
      {this.currentButton,
      this.labelText,
      this.labelFontSize = 14.0,
      this.labelColor: Colors.white,
      this.labelBackgroundColor,
      this.labelShadowColor,
      this.labelHasShadow = true,
      this.hasLabel = false})
      : assert(currentButton != null);

  Widget returnLabel() {
    return Container(
        padding: EdgeInsets.all(9.0),
        child: Text(this.labelText,
            style: TextStyle(
                fontSize: this.labelFontSize,
                fontWeight: FontWeight.bold,
                color: this.labelColor == null ? Color.fromRGBO(119, 119, 119, 1.0) : this.labelColor)));
  }

  Widget build(BuildContext context) {
    return this.currentButton;
  }
}

class UnicornContainer extends StatefulWidget {
  final int orientation;
  final Icon parentButton;
  final Icon finalButtonIcon;
  final bool hasBackground;

  /// Color of the fab button
  final Color parentButtonBackground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final int mainAnimationDuration;
  final double childPadding;

  /// Background color when modal pressed
  final Color backgroundColor;
  final Function onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  /// AnimationControllers
  final AnimationController animationController;
  final AnimationController parentController;

  UnicornContainer(
      {this.parentButton,
      this.parentButtonBackground,
      this.childButtons,
      this.onMainButtonPressed,
      this.orientation = 1,
      this.hasBackground = true,
      this.backgroundColor = Colors.black54,
      this.parentHeroTag = "parent",
      this.finalButtonIcon,
      this.animationDuration = 180,
      this.mainAnimationDuration = 200,
      this.childPadding = 4.0,
      this.animationController,
      this.parentController,
      this.hasNotch = false})
      : assert(parentButton != null);

  _UnicornContainer createState() => _UnicornContainer();
}

class _UnicornContainer extends State<UnicornContainer> with TickerProviderStateMixin {
  bool isOpen = false;

  void mainActionButtonOnPressed() {
    if (widget.animationController.isDismissed) {
      widget.animationController.forward();
    } else {
      widget.animationController.reverse();
    }
  }

  Icon getIcon() {
    if (widget.animationController != null && widget.animationController.isDismissed) {
      return widget.parentButton;
    }
    if (widget.finalButtonIcon == null) {
      return Icon(Icons.close, color: widget.parentButton.color, size: widget.parentButton.size);
    }
    return widget.finalButtonIcon;
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController.reverse();

    var hasChildButtons = widget.childButtons != null && widget.childButtons.length > 0;

    if (!widget.parentController.isAnimating) {
      if (widget.parentController.isCompleted) {
        widget.parentController.forward().then((s) {
          widget.parentController.reverse().then((e) {
            widget.parentController.forward();
          });
        });
      }
      if (widget.parentController.isDismissed) {
        widget.parentController.reverse().then((s) {
          widget.parentController.forward();
        });
      }
    }

    var mainFAB = AnimatedBuilder(
        animation: widget.parentController,
        builder: (BuildContext context, Widget child) {
          return Transform(
              transform: new Matrix4.diagonal3(vector.Vector3(
                  widget.parentController.value, widget.parentController.value, widget.parentController.value)),
              alignment: FractionalOffset.center,
              child: FloatingActionButton(
                  isExtended: false,
                  heroTag: widget.parentHeroTag,
                  backgroundColor: widget.parentButtonBackground,
                  onPressed: () {
                    mainActionButtonOnPressed();
                    if (widget.onMainButtonPressed != null) {
                      widget.onMainButtonPressed();
                    }
                  },
                  child: !hasChildButtons
                      ? widget.parentButton
                      : AnimatedBuilder(
                          animation: widget.animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              transform: new Matrix4.rotationZ(widget.animationController.value * 0.8),
                              alignment: FractionalOffset.center,
                              child: getIcon(),
                            );
                          })));
        });

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(angle: widget.animationController.value * 0.8, child: mainFAB);
          });

      var childButtonsList = widget.childButtons == null || widget.childButtons.length == 0
          ? List<Widget>()
          : List.generate(widget.childButtons.length, (index) {
              var intervalValue =
                  index == 0 ? 0.9 : ((widget.childButtons.length - index) / widget.childButtons.length) - 0.2;

              intervalValue = intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

              var childFAB = FloatingActionButton(
                  onPressed: () {
                    if (widget.childButtons[index].currentButton.onPressed != null) {
                      widget.childButtons[index].currentButton.onPressed();
                    }

                    widget.animationController.reverse();
                  },
                  child: widget.childButtons[index].currentButton.child,
                  heroTag: widget.childButtons[index].currentButton.heroTag,
                  backgroundColor: widget.childButtons[index].currentButton.backgroundColor,
                  mini: widget.childButtons[index].currentButton.mini,
                  tooltip: widget.childButtons[index].currentButton.tooltip,
                  key: widget.childButtons[index].currentButton.key,
                  elevation: widget.childButtons[index].currentButton.elevation,
                  foregroundColor: widget.childButtons[index].currentButton.foregroundColor,
                  highlightElevation: widget.childButtons[index].currentButton.highlightElevation,
                  isExtended: widget.childButtons[index].currentButton.isExtended,
                  shape: widget.childButtons[index].currentButton.shape);

              return Positioned(
                right: widget.orientation == UnicornOrientation.VERTICAL
                    ? widget.childButtons[index].currentButton.mini ? 4.0 : 0.0
                    : ((widget.childButtons.length - index) * 55.0) + 15,
                bottom: widget.orientation == UnicornOrientation.VERTICAL
                    ? ((widget.childButtons.length - index) * 55.0) + 15
                    : 8.0,
                child: Row(children: [
                  ScaleTransition(
                      scale: CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                      ),
                      alignment: FractionalOffset.center,
                      child:
                          (!widget.childButtons[index].hasLabel) || widget.orientation == UnicornOrientation.HORIZONTAL
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(right: widget.childPadding),
                                  child: widget.childButtons[index].returnLabel())),
                  ScaleTransition(
                      scale: CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                      ),
                      alignment: FractionalOffset.center,
                      child: childFAB)
                ]),
              );
            });

      var unicornDialWidget = Container(
          margin: widget.hasNotch ? EdgeInsets.only(bottom: 15.0) : null,
          height: double.infinity,
          child: Stack(
              //fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              overflow: Overflow.visible,
              children: childButtonsList.toList()
                ..add(Positioned(right: null, bottom: null, child: mainFloatingButton))));

      var modal = ScaleTransition(
          scale: CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(1.0, 1.0, curve: Curves.linear),
          ),
          alignment: FractionalOffset.center,
          child: GestureDetector(
              onTap: mainActionButtonOnPressed,
              child: Container(
                color: widget.backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )));

      if (widget.hasBackground) {
        return Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: [Positioned(right: -16.0, bottom: -16.0, child: modal), unicornDialWidget]);
      } else {
        return unicornDialWidget;
      }
    }

    return mainFAB;
  }
}

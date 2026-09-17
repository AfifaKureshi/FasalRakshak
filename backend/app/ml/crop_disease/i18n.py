# ============================================================
# FASAL RAKSHAK - MULTILINGUAL TRANSLATION ENGINE (BACKEND)
# Supports: English (en), Hindi (hi), Marathi (mr), Gujarati (gu)
# ============================================================

SEVERITY_TRANSLATIONS = {
    "hi": {
        "Low": "कम (Low)",
        "Moderate": "मध्यम (Moderate)",
        "High": "उच्च / गंभीर (High)",
        "Severe": "अति गंभीर (Severe)",
        "Critical": "अति संकटपूर्ण (Critical)",
    },
    "mr": {
        "Low": "कमी (Low)",
        "Moderate": "मध्यम (Moderate)",
        "High": "उच्च / गंभीर (High)",
        "Severe": "अति गंभीर (Severe)",
        "Critical": "अति संकटपूर्ण (Critical)",
    },
    "gu": {
        "Low": "ઓછું (Low)",
        "Moderate": "મધ્યમ (Moderate)",
        "High": "ઉચ્ચ / ગંભીર (High)",
        "Severe": "અતિ ગંભીર (Severe)",
        "Critical": "અતિ સંકટપૂર્ણ (Critical)",
    },
}

CROP_TRANSLATIONS = {
    "hi": {
        "Apple": "सेब", "Blueberry": "ब्लूबेरी", "Cherry": "चेरी",
        "Corn": "मक्का", "Corn (Maize)": "मक्का", "Grape": "अंगूर",
        "Orange": "संतरा", "Peach": "आड़ू", "Pepper (Bell)": "शिमला मिर्च",
        "Potato": "आलू", "Raspberry": "रास्पबेरी", "Soybean": "सोयाबीन",
        "Squash": "स्क्वैश", "Strawberry": "स्ट्रॉबेरी", "Tomato": "टमाटर",
        "Cotton": "कपास", "Groundnut": "मूंगफली"
    },
    "mr": {
        "Apple": "सफरचंद", "Blueberry": "ब्लूबेरी", "Cherry": "चेरी",
        "Corn": "मका", "Corn (Maize)": "मका", "Grape": "द्राक्ष",
        "Orange": "संत्रे", "Peach": "पीच", "Pepper (Bell)": "ढोबळी मिरची",
        "Potato": "बटाटा", "Raspberry": "रास्पबेरी", "Soybean": "सोयाबीन",
        "Squash": "स्क्वॅश", "Strawberry": "स्ट्रॉबेरी", "Tomato": "टोमॅटो",
        "Cotton": "कापूस", "Groundnut": "भुईमूग"
    },
    "gu": {
        "Apple": "સફરજન", "Blueberry": "બ્લુબેરી", "Cherry": "ચેરી",
        "Corn": "મકાઈ", "Corn (Maize)": "મકાઈ", "Grape": "દ્રાક્ષ",
        "Orange": "નારંગી", "Peach": "પીચ", "Pepper (Bell)": "કેપ્સિકમ",
        "Potato": "બટાકા", "Raspberry": "રાસ્પબેરી", "Soybean": "સોયાબીન",
        "Squash": "સ્ક્વોશ", "Strawberry": "સ્ટ્રોબેરી", "Tomato": "ટામેટા",
        "Cotton": "કપાસ", "Groundnut": "મગફળી"
    }
}

DISEASE_NAME_TRANSLATIONS = {
    "hi": {
        "Apple Scab": "सेब का स्कैब रोग (Apple Scab)",
        "Black Rot": "काला सड़न रोग (Black Rot)",
        "Cedar Apple Rust": "देवदार सेब रतुआ (Cedar Apple Rust)",
        "Powdery Mildew": "छाछिया / चूर्णिल आसिता (Powdery Mildew)",
        "Gray Leaf Spot": "ग्रे लीफ स्पॉट / पत्ती धब्बा",
        "Common Rust": "सामान्य रतुआ रोग (Common Rust)",
        "Northern Leaf Blight": "उत्तरी पत्ती झुलसा (Northern Leaf Blight)",
        "Esca (Black Measles)": "एस्का / काला खसरा (Esca)",
        "Leaf Blight": "पत्ती झुलसा (Leaf Blight)",
        "Huanglongbing (Citrus Greening)": "सिट्रस ग्रीनिंग / पीला रोग (Citrus Greening)",
        "Bacterial Spot": "जीवाणु धब्बा रोग (Bacterial Spot)",
        "Early Blight": "अगेती झुलसा (Early Blight)",
        "Late Blight": "पछेती झुलसा (Late Blight)",
        "Leaf Scorch": "पत्ती झुलसन (Leaf Scorch)",
        "Leaf Mold": "पत्ती का फफूंद (Leaf Mold)",
        "Septoria Leaf Spot": "सेप्टोरिया पत्ती धब्बा (Septoria Leaf Spot)",
        "Two-Spotted Spider Mite Infestation": "लाल मकड़ी कीट प्रकोप (Spider Mites)",
        "Spider Mites": "लाल मकड़ी कीट (Spider Mites)",
        "Target Spot": "टारगेट स्पॉट रोग",
        "Tomato Yellow Leaf Curl Virus": "टमाटर पीला पत्ती मरोड़िया वायरस (TYLCV)",
        "Tomato Mosaic Virus": "टमाटर मोज़ेक वायरस (ToMV)",
        "Healthy": "स्वस्थ फसल (Healthy)",
        "Rust": "रतुआ रोग (Rust)",
        "Scab": "स्कैब रोग (Scab)",
        "Multiple Diseases": "एकाधिक रोग संक्रमण (Multiple Infections)",
    },
    "mr": {
        "Apple Scab": "सफरचंद स्कॅब रोग (Apple Scab)",
        "Black Rot": "काळा कुजवा रोग (Black Rot)",
        "Cedar Apple Rust": "तांबेरा रोग (Cedar Apple Rust)",
        "Powdery Mildew": "भुरी रोग (Powdery Mildew)",
        "Gray Leaf Spot": "राखाडी पानांवरील ठिपके (Gray Leaf Spot)",
        "Common Rust": "तांबेरा रोग (Common Rust)",
        "Northern Leaf Blight": "पानावरील करपा रोग (Northern Leaf Blight)",
        "Esca (Black Measles)": "एस्का रोग (Esca Black Measles)",
        "Leaf Blight": "पानावरील करपा (Leaf Blight)",
        "Huanglongbing (Citrus Greening)": "सिट्रस ग्रीनिंग रोग (Citrus Greening)",
        "Bacterial Spot": "जिवाणूजन्य ठिपके (Bacterial Spot)",
        "Early Blight": "लवकर येणारा करपा (Early Blight)",
        "Late Blight": "उशिरा येणारा करपा (Late Blight)",
        "Leaf Scorch": "पाने जळणे (Leaf Scorch)",
        "Leaf Mold": "पानावरील बुरशी (Leaf Mold)",
        "Septoria Leaf Spot": "सेप्टोरिया पानावरील ठिपके (Septoria)",
        "Two-Spotted Spider Mite Infestation": "लाल कोळी कीड प्रादुर्भाव (Spider Mites)",
        "Spider Mites": "लाल कोळी कीड (Spider Mites)",
        "Target Spot": "टार्गेट स्पॉट बुरशी रोग",
        "Tomato Yellow Leaf Curl Virus": "टोमॅटो पिवळा पर्णगुच्छ विषाणू (TYLCV)",
        "Tomato Mosaic Virus": "टोमॅटो मोझॅक विषाणू (ToMV)",
        "Healthy": "निरोगी पीक (Healthy)",
        "Rust": "तांबेरा रोग (Rust)",
        "Scab": "स्कॅब रोग (Scab)",
        "Multiple Diseases": "एकाधिक रोग प्रादुर्भाव (Multiple Infections)",
    },
    "gu": {
        "Apple Scab": "સફરજન સ્કેબ રોગ (Apple Scab)",
        "Black Rot": "કાળો સડો રોગ (Black Rot)",
        "Cedar Apple Rust": "ગેરૂ રોગ (Cedar Apple Rust)",
        "Powdery Mildew": "છાશિયો રોગ (Powdery Mildew)",
        "Gray Leaf Spot": "રાખોડી પાનના ટપકા (Gray Leaf Spot)",
        "Common Rust": "સામાન્ય ગેરુ રોગ (Common Rust)",
        "Northern Leaf Blight": "ઉત્તરી પાન સુકારો (Northern Leaf Blight)",
        "Esca (Black Measles)": "એસ્કા રોગ (Esca)",
        "Leaf Blight": "પાનનો સુકારો (Leaf Blight)",
        "Huanglongbing (Citrus Greening)": "સિટ્રસ ગ્રીનિંગ રોગ (Citrus Greening)",
        "Bacterial Spot": "બેક્ટેરિયલ ટપકાંનો રોગ (Bacterial Spot)",
        "Early Blight": "અગેતી સુકારો (Early Blight)",
        "Late Blight": "પાછોતરો સુકારો (Late Blight)",
        "Leaf Scorch": "પાન બળવા રોગ (Leaf Scorch)",
        "Leaf Mold": "પાનની ફૂગ (Leaf Mold)",
        "Septoria Leaf Spot": "સેપ્ટોરિયા ટપકાં રોગ (Septoria)",
        "Two-Spotted Spider Mite Infestation": "લાલ કથીરી ઉપદ્રવ (Spider Mites)",
        "Spider Mites": "લાલ કથીરી (Spider Mites)",
        "Target Spot": "ટાર્ગેટ સ્પોટ રોગ",
        "Tomato Yellow Leaf Curl Virus": "ટામેટા પીળો પર્ણ વલન વાયરસ (TYLCV)",
        "Tomato Mosaic Virus": "ટામેટા મોઝેક વાયરસ (ToMV)",
        "Healthy": "તંદુરસ્ત પાક (Healthy)",
        "Rust": "ગેરુ રોગ (Rust)",
        "Scab": "સ્કેબ રોગ (Scab)",
        "Multiple Diseases": "બહુવિધ રોગ ચેપ (Multiple Infections)",
    }
}

DETAILED_DISEASE_METADATA_I18N = {
    "hi": {
        "Potato___Early_blight": {
            "disease": "अगेती झुलसा (Early Blight)",
            "crop": "आलू",
            "severity": "मध्यम (Moderate)",
            "explanation": "मॉडल ने आलू की पत्तियों पर अल्टरनेरिया सोलानी फफूंद के लक्षण पहचाने हैं। निचली पत्तियों पर भूरे-काले संकेंद्रित छल्लेदार धब्बे (टारगेट बोर्ड पैटर्न) दिखाई देते हैं।",
            "recommendations": "मैंकोजेब 75% WP (2.5 ग्राम/लीटर) या एज़ोक्सीस्ट्रोबिन 23% SC (1 मिली/लीटर) का तुरंत छिड़काव करें। मिट्टी को छूने वाली पुरानी रोगी पत्तियों को हटा दें।",
            "prevention": "फसल चक्र अपनाएं, खेत में जलभराव न होने दें और पत्तों की रोग प्रतिरोधक क्षमता बढ़ाने हेतु संतुलित पोटाश व सूक्ष्म पोषक तत्वों का उपयोग करें।"
        },
        "Potato___Late_blight": {
            "disease": "पछेती झुलसा (Late Blight)",
            "crop": "आलू",
            "severity": "उच्च / गंभीर (High)",
            "explanation": "मॉडल ने आलू की पत्तियों पर फाइटोफ्थोरा इन्फेस्टन्स (Phytophthora infestans) का गंभीर संक्रमण पाया है। पत्तियों पर गहरे भूरे, पानी से भीगे हुए धब्बे तेजी से फैलते हैं और अत्यधिक नमी में सफेद फफूंद दिखती है।",
            "recommendations": "मेटालेक्सिल + मैंकोजेब 72% WP (2.5 ग्राम/लीटर) या साइमोक्सानिल + मैंकोजेब का तुरंत छिड़काव करें। रोगग्रस्त पौधों और अवशेषों को तुरंत नष्ट करें।",
            "prevention": "फव्वारा सिंचाई से बचें ताकि पत्तियों पर अधिक देर तक नमी न रहे। प्रमाणित रोगमुक्त कंद ही बोएं और खेत में उचित जल निकासी सुनिश्चित करें।"
        },
        "Potato___healthy": {
            "disease": "स्वस्थ फसल (Healthy)",
            "crop": "आलू",
            "severity": "कम (Low)",
            "explanation": "मॉडल द्वारा जांचे गए आलू के पत्ते पूर्णतः स्वस्थ हैं और किसी प्रमुख कवक या जीवाणु रोग के लक्षण नहीं मिले हैं।",
            "recommendations": "संतुलित सिंचाई और पोषण (NPK) चक्र जारी रखें। साप्ताहिक निगरानी बनाए रखें।",
            "prevention": "खेत की स्वच्छता बनाए रखें और कीटों की समय पर रोकथाम के लिए निगरानी रखें।"
        },
        "Tomato___Early_blight": {
            "disease": "अगेती झुलसा (Early Blight)",
            "crop": "टमाटर",
            "severity": "मध्यम (Moderate)",
            "explanation": "टमाटर के पत्तों पर अल्टरनेरिया कवक के लक्षण हैं। पत्तियों पर गोलाकार भूरे धब्बे और चारों ओर पीलापन देखा गया है।",
            "recommendations": "क्लोरोथैलोनिल या मैंकोजेब 75% WP (2 ग्राम/लीटर) का छिड़काव करें। हवा का संचार बेहतर करने के लिए छंटाई करें।",
            "prevention": "टमाटर के बाद सोलेनेसी कुल की फसलें न लगाएं। मल्चिंग करें जिससे मिट्टी के बीजाणु पत्तों तक न पहुंचें।"
        },
        "Tomato___Late_blight": {
            "disease": "पछेती झुलसा (Late Blight)",
            "crop": "टमाटर",
            "severity": "उच्च / गंभीर (High)",
            "explanation": "टमाटर पर पछेती झुलसा (Phytophthora) का तीव्र प्रकोप पाया गया है। ठंडे और नम मौसम में यह रोग तेजी से पूरे पौधे को नष्ट कर सकता है।",
            "recommendations": "कॉपर ऑक्सीक्लोराइड 50% WP (3 ग्राम/लीटर) या डैफामेथोमॉर्फ + मैंकोजेब का सुरक्षात्मक छिड़काव करें।",
            "prevention": "ड्रिप सिंचाई प्रणाली का उपयोग करें ताकि पत्तियां सूखी रहें। पौधों के बीच पर्याप्त दूरी रखें।"
        },
        "Tomato___healthy": {
            "disease": "स्वस्थ फसल (Healthy)",
            "crop": "टमाटर",
            "severity": "कम (Low)",
            "explanation": "टमाटर के पत्ते स्वस्थ हैं, क्लोरोफिल स्तर सामान्य है और कोई विकृति नहीं है।",
            "recommendations": "सामान्य उर्वरक और सिंचाई जारी रखें।",
            "prevention": "सफेद मक्खी और थ्रिप्स कीटों से बचाव हेतु पीले चिपचिपे ट्रैप लगाएं।"
        },
        "Corn___Common_rust": {
            "disease": "सामान्य रतुआ (Common Rust)",
            "crop": "मक्का",
            "severity": "मध्यम (Moderate)",
            "explanation": "मक्के की पत्तियों की दोनों सतहों पर लाल-भूरे रंग के उभरे हुए बीजाणु दाने (Pustules) पाए गए हैं।",
            "recommendations": "टेबुकोनाज़ोल 25.9% EC (1 मिली/लीटर) या एज़ोक्सीस्ट्रोबिन का पर्णीय छिड़काव करें।",
            "prevention": "रतुआ-रोधी हाइब्रिड किस्मों का चयन करें और पोटाश का उचित संतुलन रखें।"
        },
        "Corn___healthy": {
            "disease": "स्वस्थ फसल (Healthy)",
            "crop": "मक्का",
            "severity": "कम (Low)",
            "explanation": "मक्के की फसल स्वस्थ है और पत्तियां पूरी तरह सामान्य हैं।",
            "recommendations": "नाइट्रोजन की अनुशंसित मात्रा दें और मिट्टी में नमी बनाए रखें।",
            "prevention": "फॉल आर्मीवर्म कीट के लिए फेरोमोन ट्रैप लगाएं।"
        },
        "Apple___Apple_scab": {
            "disease": "सेब का स्कैब (Apple Scab)",
            "crop": "सेब",
            "severity": "मध्यम (Moderate)",
            "explanation": "सेब की पत्तियों पर जैतूनी-हरे से भूरे गोलाकार धब्बे पाए गए हैं।",
            "recommendations": "डाइफेनोकोनाज़ोल 25% EC (0.5 मिली/लीटर) या कैप्टान का छिड़काव करें।",
            "prevention": "गिरे हुए संक्रमित पत्तों को इकट्ठा कर नष्ट करें। कैनोपी में हवा का संचार बढ़ाएं।"
        },
        "Apple___healthy": {
            "disease": "स्वस्थ फसल (Healthy)",
            "crop": "सेब",
            "severity": "कम (Low)",
            "explanation": "सेब के पत्ते पूर्णतः स्वस्थ हैं।",
            "recommendations": "नियमित फफूंदनाशक सुरक्षात्मक शेड्यूल का पालन करें।",
            "prevention": "बाग की स्वच्छता रखें।"
        },
        "Cotton___healthy": {
            "disease": "स्वस्थ फसल (Healthy)",
            "crop": "कपास",
            "severity": "कम (Low)",
            "explanation": "कपास की पत्तियां स्वस्थ हैं, कोई जीवाणु झुलसा या कीट क्षति नहीं है।",
            "recommendations": "19:19:19 NPK + सूक्ष्म पोषक तत्वों का पर्णीय छिड़काव जारी रखें।",
            "prevention": "सफेद मक्खी और गुलाबी सुंडी की निगरानी हेतु फेरोमोन व पीले स्टिकी ट्रैप लगाएं।"
        }
    },
    "mr": {
        "Potato___Early_blight": {
            "disease": "लवकर येणारा करपा (Early Blight)",
            "crop": "बटाटा",
            "severity": "मध्यम (Moderate)",
            "explanation": "मॉडेलला बटाट्याच्या पानांवर अल्टरनेरिया बुरशीचे लक्षण आढळले आहे. जुन्या खालच्या पानांवर एकाआड एक गोलाकार तपकिरी ते काळे वलय असणारे ठिपके दिसत आहेत.",
            "recommendations": "मॅन्कोझेब ७५% WP (२.५ ग्रॅम/लिटर) किंवा अझॉक्सीस्ट्रोबिन २३% SC (१ मिली/लिटर) ची तत्काळ फवारणी करा. जमिनीला टेकलेली रोगट पाने काढून टाका.",
            "prevention": "किमान ३ वर्षे फेरपालट करा. पानांची प्रतिकारशक्ती वाढवण्यासाठी संतुलित पोटॅश खत द्या आणि जास्त ओलसरपणा टाळा."
        },
        "Potato___Late_blight": {
            "disease": "उशिरा येणारा करपा (Late Blight)",
            "crop": "बटाटा",
            "severity": "उच्च / गंभीर (High)",
            "explanation": "मॉडेलला बटाट्यावर फायटोफ्थोरा इन्फेस्टन्स (Phytophthora infestans) बुरशीचा तीव्र प्रादुर्भाव आढळला आहे. पानांवर काळपट तपकिरी, पाण्यासारखे डाग वेगाने पसरत आहेत.",
            "recommendations": "मेटालॅक्सिल + मॅन्कोझेब ७२% WP (२.५ ग्रॅम/लिटर) किंवा सिमॉक्सॅनिल + मॅन्कोझेब ची तातडीने फवारणी करा. अतिबाधित झाडे काढून नष्ट करा.",
            "prevention": "तुषार सिंचन टाळा जेणेकरून पानांवर सतत पाणी राहणार नाही. निरोगी आणि प्रमाणित बियाणेच वापरा."
        },
        "Potato___healthy": {
            "disease": "निरोगी पीक (Healthy)",
            "crop": "बटाटा",
            "severity": "कमी (Low)",
            "explanation": "तपासलेली बटाट्याची पाने पूर्णपणे निरोगी असून कोणत्याही रोगाचे लक्षण नाही.",
            "recommendations": "नियमित खत आणि पाणी व्यवस्थापन सुरू ठेवा. पिकाचे नियमित निरीक्षण करा.",
            "prevention": "शेत स्वच्छ ठेवा आणि रसशोषक किडींवर लक्ष ठेवा."
        },
        "Tomato___Early_blight": {
            "disease": "लवकर येणारा करपा (Early Blight)",
            "crop": "टोमॅटो",
            "severity": "मध्यम (Moderate)",
            "explanation": "टोमॅटोच्या पानांवर अल्टरनेरिया बुरशीचे गोलाकार तपकिरी ठिपके आणि पिवळे वलय दिसून येत आहे.",
            "recommendations": "क्लोरोथॅलोनिल किंवा मॅन्कोझेब ७५% WP (२ ग्रॅम/लिटर) ची फवारणी करा. झाडांना आधार देऊन हवा खेळती ठेवा.",
            "prevention": "मल्चिंगचा वापर करा आणि जमिनीतून पाण्याचे थेंब पानांवर उडणार नाहीत याची काळजी घ्या."
        },
        "Tomato___Late_blight": {
            "disease": "उशिरा येणारा करपा (Late Blight)",
            "crop": "टोमॅटो",
            "severity": "उच्च / गंभीर (High)",
            "explanation": "टोमॅटोवर अत्यंत विध्वंसक लेट ब्लाईट करपा रोगाची लागण झाली आहे. दमट थंड हवामानात हा रोग वेगाने पसरतो.",
            "recommendations": "कॉपर ऑक्सिक्लोराईड ५०% WP (३ ग्रॅम/लिटर) किंवा डायमेथोमॉर्फ बुरशीनाशकाची तत्काळ फवारणी करा.",
            "prevention": "ठिबक सिंचन वापरा. झाडांमध्ये पुरेशी जागा ठेवा."
        },
        "Tomato___healthy": {
            "disease": "निरोगी पीक (Healthy)",
            "crop": "टोमॅटो",
            "severity": "कमी (Low)",
            "explanation": "टोमॅटोचे पीक उत्तम असून पाने निरोगी आहेत.",
            "recommendations": "योग्य पोषण आणि सूक्ष्मअन्नद्रव्यांची फवारणी चालू ठेवा.",
            "prevention": "पांढऱ्या माशीच्या नियंत्रणासाठी पिवळे चिकट सापळे लावा."
        },
        "Cotton___healthy": {
            "disease": "निरोगी पीक (Healthy)",
            "crop": "कापूस",
            "severity": "कमी (Low)",
            "explanation": "कापसाची पाने निरोगी असून कोणताही रोग किंवा कीड आढळलेली नाही.",
            "recommendations": "१९:१९:१९ विद्राव्य खत आणि सूक्ष्मद्रव्यांची फवारणी करा.",
            "prevention": "गुलाबी बोंडअळी व पांढऱ्या माशीच्या नियंत्रणासाठी कामगंध व चिकट सापळे लावा."
        }
    },
    "gu": {
        "Potato___Early_blight": {
            "disease": "અગેતી સુકારો (Early Blight)",
            "crop": "બટાકા",
            "severity": "મધ્યમ (Moderate)",
            "explanation": "મોડેલ દ્વારા બટાકાના પાન પર અલ્ટરનેરિયા સોલાની ફૂગના લક્ષણો મળ્યા છે. નીચેના જૂના પાન પર ગોળાકાર કથ્થઈ રંગના વલયો (ટાર્ગેટ બોર્ડ પેટર્ન) જોવા મળે છે.",
            "recommendations": "મેન્કોઝેબ ૭૫% WP (૨.૫ ગ્રામ/લીટર) અથવા એઝોક્સીસ્ટ્રોબિન ૨૩% SC (૧ મિલી/લીટર) નો તાત્કાલિક છંટકાવ કરો. જમીનને અડતા રોગિષ્ટ પાંદડા દૂર કરો.",
            "prevention": "પાકની ફેરબદલી કરો, જમીનમાં પાણીનો ભરાવો ન થવા દો અને પાનની રોગપ્રતિકારક શક્તિ વધારવા પૂરતું પોટાશ ખાતર આપો."
        },
        "Potato___Late_blight": {
            "disease": "પાછોતરો સુકારો (Late Blight)",
            "crop": "બટાકા",
            "severity": "ઉચ્ચ / ગંભીર (High)",
            "explanation": "મોડેલ દ્વારા બટાકાના પાક પર ફાયટોપ્થોરા (Phytophthora infestans) ફૂગનો ગંભીર ચેપ જણાયો છે. પાન પર કાળા-કથ્થઈ પાણીપોચા ડાઘ ઝડપથી ફેલાય છે.",
            "recommendations": "મેટાલેક્સિલ + મેન્કોઝેબ ૭૨% WP (૨.૫ ગ્રામ/લીટર) અથવા સાયમોક્સાનીલ + મેન્કોઝેબનો તાત્કાલિક છંટકાવ કરો. ગંભીર અસરગ્રસ્ત છોડનો નાશ કરો.",
            "prevention": "ફુવારા પદ્ધતિથી પિયત ટાળો જેથી પાન ભીના ન રહે. પ્રમાણિત અને રોગમુક્ત બિયારણ જ વાવો."
        },
        "Potato___healthy": {
            "disease": "તંદુરસ્ત પાક (Healthy)",
            "crop": "બટાકા",
            "severity": "ઓછું (Low)",
            "explanation": "બટાકાના પાન સંપૂર્ણપણે તંદુરસ્ત છે અને કોઈ રોગના લક્ષણો જણાયા નથી.",
            "recommendations": "નિયમિત ખાતર અને પિયત વ્યવસ્થાપન ચાલુ રાખો.",
            "prevention": "ખેતર સાફ રાખો અને જીવાતોની દેખરેખ રાખો."
        },
        "Tomato___Early_blight": {
            "disease": "અગેતી સુકારો (Early Blight)",
            "crop": "ટામેટા",
            "severity": "મધ્યમ (Moderate)",
            "explanation": "ટામેટાના પાન પર અલ્ટરનેરિયા ફૂગના ગોળાકાર કથ્થઈ ટપકાં અને પીળું કુંડાળું જોવા મળ્યું છે.",
            "recommendations": "ક્લોરોથેલોનીલ અથવા મેન્કોઝેબ ૭૫% WP (૨ ગ્રામ/લીટર) નો છંટકાવ કરો. હવાના ઉજાસ માટે છોડની છાંટણી કરો.",
            "prevention": "મલ્ચિંગ કરો જેથી જમીનમાંથી ફૂગના બીજાણુ પાન સુધી ન ઉડે."
        },
        "Tomato___Late_blight": {
            "disease": "પાછોતરો સુકારો (Late Blight)",
            "crop": "ટામેટા",
            "severity": "ઉચ્ચ / ગંભીર (High)",
            "explanation": "ટામેટાના પાક પર પાછોતરા સુકારાનો ભારે ઉપદ્રવ છે. ભેજવાળા ઠંડા વાતાવરણમાં આ રોગ ઝડપથી આખા છોડને નુકસાન પહોંચાડે છે.",
            "recommendations": "કોપર ઓક્સીક્લોરાઇડ ૫૦% WP (૩ ગ્રામ/લીટર) અથવા ડાયમેથોમોર્ફનો તાત્કાલિક છંટકાવ કરો.",
            "prevention": "ટપક પિયત પદ્ધતિનો ઉપયોગ કરો અને બે છોડ વચ્ચે પૂરતું અંતર રાખો."
        },
        "Tomato___healthy": {
            "disease": "તંદુરસ્ત પાક (Healthy)",
            "crop": "ટામેટા",
            "severity": "ઓછું (Low)",
            "explanation": "ટામેટાનો પાક ઉત્તમ છે અને પાન એકદમ તંદુરસ્ત છે.",
            "recommendations": "સામાન્ય પોષણ અને પિયત ચાલુ રાખો.",
            "prevention": "સફેદ માખીના નિયંત્રણ માટે પીળા સ્ટીકી ટ્રેપ લગાવો."
        },
        "Cotton___healthy": {
            "disease": "તંદુરસ્ત પાક (Healthy)",
            "crop": "કપાસ",
            "severity": "ઓછું (Low)",
            "explanation": "કપાસના પાન સંપૂર્ણ સ્વસ્થ છે અને કોઈ જીવાત કે રોગ નથી.",
            "recommendations": "૧૯:૧૯:૧૯ એનપીકે અને સૂક્ષ્મ તત્વોનો છંટકાવ ચાલુ રાખો.",
            "prevention": "ગુલાબી ઈયળ અને સફેદ માખીના નિયંત્રણ માટે ફેરોમોન અને પીળા ટ્રેપ લગાવો."
        }
    }
}

def translate_diagnosis(result: dict, lang: str = "en") -> dict:
    """
    Translates a diagnosis result dictionary into the requested language (hi, mr, gu).
    Falls back gracefully if language is en or translation is not found.
    """
    if not result or lang not in ("hi", "mr", "gu"):
        return result

    res = dict(result)
    # An uncertain result must never be translated into treatment advice.
    if res.get("disease") == "Unable to Determine" or res.get("disease_detected") == "Unable to Determine":
        texts = {
            "hi": ("विश्वसनीय पहचान नहीं हुई", "अज्ञात", "फोटो की विश्वसनीय पहचान नहीं हुई। संभावित स्कोर पक्का निदान नहीं हैं।", "एक पत्ती का साफ फोटो लें और उपचार से पहले कृषि विशेषज्ञ की सलाह लें।", "फसल पर नजर रखें और बदलते लक्षणों का रिकॉर्ड रखें।"),
            "mr": ("विश्वसनीय ओळख झाली नाही", "अज्ञात", "फोटोची विश्वसनीय ओळख झाली नाही. संभाव्य स्कोअर हे निश्चित निदान नाही.", "एका पानाचा स्पष्ट फोटो घ्या आणि उपचारापूर्वी कृषी तज्ज्ञांचा सल्ला घ्या.", "पिकावर लक्ष ठेवा आणि बदलत्या लक्षणांची नोंद ठेवा."),
            "gu": ("વિશ્વસનીય ઓળખ થઈ નથી", "અજ્ઞાત", "ફોટોની વિશ્વસનીય ઓળખ થઈ નથી. સંભવિત સ્કોર ખાતરીપૂર્વકનું નિદાન નથી.", "એક પાનનો સ્પષ્ટ ફોટો લો અને સારવાર પહેલાં કૃષિ નિષ્ણાતની સલાહ લો.", "પાક પર નજર રાખો અને બદલાતાં લક્ષણોની નોંધ રાખો."),
        }[lang]
        res.update(dict(zip(("disease", "severity", "explanation", "recommendations", "prevention"), texts)))
        res["disease_detected"] = res["disease"]
        return res
    crop = res.get("crop") or res.get("crop_name", "")
    disease = res.get("disease") or res.get("disease_detected", "")
    class_key = f"{crop}___{disease.replace(' ', '_')}"

    # 1. Check detailed custom entry
    detailed_map = DETAILED_DISEASE_METADATA_I18N.get(lang, {})
    matched_detail = None
    for k, v in detailed_map.items():
        if k.lower() == class_key.lower() or (crop.lower() in k.lower() and disease.lower() in k.lower()):
            matched_detail = v
            break

    if matched_detail:
        res["disease"] = matched_detail.get("disease", disease)
        res["disease_detected"] = matched_detail.get("disease", disease)
        res["crop"] = matched_detail.get("crop", crop)
        res["crop_name"] = matched_detail.get("crop", crop)
        res["severity"] = {"hi": "मापा नहीं गया", "mr": "मोजलेले नाही", "gu": "માપવામાં આવ્યું નથી"}[lang] if result.get("severity") == "Not assessed" else matched_detail.get("severity", res.get("severity"))
        res["explanation"] = matched_detail.get("explanation", res.get("explanation"))
        res["recommendations"] = matched_detail.get("recommendations", res.get("recommendations"))
        res["prevention"] = matched_detail.get("prevention", res.get("prevention"))
        return res

    # 2. General component translation
    # Translate disease name
    d_trans = DISEASE_NAME_TRANSLATIONS.get(lang, {}).get(disease)
    if not d_trans:
        for eng_d, trans_d in DISEASE_NAME_TRANSLATIONS.get(lang, {}).items():
            if eng_d.lower() in disease.lower():
                d_trans = trans_d
                break
    if d_trans:
        res["disease"] = d_trans
        res["disease_detected"] = d_trans

    # Translate crop name
    c_trans = CROP_TRANSLATIONS.get(lang, {}).get(crop)
    if c_trans:
        res["crop"] = c_trans
        res["crop_name"] = c_trans

    # Translate severity
    raw_sev = res.get("severity", "Moderate")
    if raw_sev == "Not assessed":
        res["severity"] = {"hi": "मापा नहीं गया", "mr": "मोजलेले नाही", "gu": "માપવામાં આવ્યું નથી"}[lang]
    s_trans = SEVERITY_TRANSLATIONS.get(lang, {}).get(raw_sev)
    if s_trans:
        res["severity"] = s_trans

    # Generate localized generic explanation/recommendation if in non-English
    target_crop = res.get("crop", crop)
    target_disease = res.get("disease", disease)
    if lang == "hi":
        res["explanation"] = f"AI मॉडल ने {target_crop} की पत्ती पर {target_disease} के लक्षण पहचाने हैं।"
        res["recommendations"] = "उपचार से पहले कृषि विशेषज्ञ से स्थिति की पुष्टि करवाएँ।"
        res["prevention"] = "खेत में स्वच्छता बनाए रखें, फसल अवशेष नष्ट करें और पत्तियों पर नमी कम करने हेतु जल निकासी सुधारें।"
    elif lang == "mr":
        res["explanation"] = f"AI मॉडेलने {target_crop} च्या पानांवर {target_disease} चे लक्षण शोधले आहेत."
        res["recommendations"] = "उपचारापूर्वी कृषी तज्ज्ञांकडून स्थितीची खात्री करून घ्या."
        res["prevention"] = "शेताची स्वच्छता ठेवा, हवा खेळती राहू द्या आणि पाण्याचा निचरा योग्य ठेवा."
    elif lang == "gu":
        res["explanation"] = f"AI મોડેલ દ્વારા {target_crop} ના પાન પર {target_disease} ના ચિહ્નો જણાયા છે."
        res["recommendations"] = "સારવાર પહેલાં કૃષિ નિષ્ણાત પાસે સ્થિતિની ખાતરી કરાવો."
        res["prevention"] = "ખેતરમાં સ્વચ્છતા જાળવો, પાકના અવશેષો દૂર કરો અને પાણીનો યોગ્ય નિકાલ રાખો."

    return res

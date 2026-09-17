# ============================================================
# FASAL RAKSHAK - DISEASE METADATA
# PlantVillage 38 Classes
# ============================================================

DISEASE_METADATA = {

    # ========================================================
    # APPLE
    # ========================================================

    "Apple___Apple_scab": {
        "disease": "Apple Scab",
        "crop": "Apple",
        "severity": "Moderate",
        "explanation": (
            "Model detected Apple scab on Apple. "
            "The disease commonly causes olive-green to brown circular "
            "spots on leaves and can produce dark scabby lesions on fruits."
        ),
        "recommendations": (
            "Remove heavily infected leaves and fruit debris. "
            "Improve air circulation and use an appropriate fungicide "
            "according to locally approved crop protection guidelines."
        ),
        "prevention": (
            "Use resistant varieties where available, maintain orchard "
            "sanitation, prune dense growth, and avoid prolonged leaf wetness."
        )
    },

    "Apple___Black_rot": {
        "disease": "Black Rot",
        "crop": "Apple",
        "severity": "High",
        "explanation": (
            "Model detected Black rot on Apple. "
            "Symptoms include circular brown or purple leaf spots, "
            "fruit decay, and blackened or shriveled fruit."
        ),
        "recommendations": (
            "Remove infected fruit, dead wood, and severely affected plant "
            "material. Follow locally approved fungicide recommendations "
            "for black rot management."
        ),
        "prevention": (
            "Maintain orchard sanitation, remove mummified fruit, prune "
            "dead branches, and minimize wounds to plant tissue."
        )
    },

    "Apple___Cedar_apple_rust": {
        "disease": "Cedar Apple Rust",
        "crop": "Apple",
        "severity": "Moderate",
        "explanation": (
            "Model detected Cedar apple rust on Apple. "
            "The disease produces yellow-orange leaf spots and may cause "
            "premature leaf drop during severe infections."
        ),
        "recommendations": (
            "Remove severely affected plant material and follow locally "
            "approved fungicide recommendations when disease pressure is high."
        ),
        "prevention": (
            "Maintain orchard sanitation, monitor new growth regularly, "
            "and manage nearby alternate hosts where practical."
        )
    },

    "Apple___healthy": {
        "disease": "Healthy",
        "crop": "Apple",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Apple foliage with no major disease "
            "symptoms associated with the classes covered by this model."
        ),
        "recommendations": (
            "Continue normal crop management, irrigation, nutrition, "
            "and regular disease monitoring."
        ),
        "prevention": (
            "Maintain good orchard sanitation and regularly inspect leaves "
            "and fruit for early symptoms."
        )
    },


    # ========================================================
    # BLUEBERRY
    # ========================================================

    "Blueberry___healthy": {
        "disease": "Healthy",
        "crop": "Blueberry",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Blueberry foliage with no major disease "
            "symptoms associated with the PlantVillage classes."
        ),
        "recommendations": (
            "Continue balanced nutrition, irrigation, and routine crop monitoring."
        ),
        "prevention": (
            "Maintain field sanitation, adequate spacing, and good air circulation."
        )
    },


    # ========================================================
    # CHERRY
    # ========================================================

    "Cherry___Powdery_mildew": {
        "disease": "Powdery Mildew",
        "crop": "Cherry",
        "severity": "Moderate",
        "explanation": (
            "Model detected Powdery mildew on Cherry. "
            "The disease commonly appears as a white powder-like growth "
            "on young leaves and shoots."
        ),
        "recommendations": (
            "Remove severely affected plant material and improve canopy "
            "air circulation. Use an appropriate approved fungicide when necessary."
        ),
        "prevention": (
            "Avoid excessive nitrogen, maintain proper plant spacing, "
            "and monitor young foliage regularly."
        )
    },

    "Cherry___healthy": {
        "disease": "Healthy",
        "crop": "Cherry",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Cherry foliage without major symptoms "
            "represented in the PlantVillage dataset."
        ),
        "recommendations": (
            "Continue regular irrigation, nutrition, and crop monitoring."
        ),
        "prevention": (
            "Maintain orchard hygiene and regularly inspect new foliage."
        )
    },


    # ========================================================
    # CORN
    # ========================================================

    "Corn___Cercospora_leaf_spot Gray_leaf_spot": {
        "disease": "Gray Leaf Spot",
        "crop": "Corn",
        "severity": "High",
        "explanation": (
            "Model detected Gray leaf spot on Corn. "
            "The disease produces elongated gray or tan lesions on leaves "
            "and can reduce photosynthetic activity."
        ),
        "recommendations": (
            "Improve field management and follow locally approved fungicide "
            "recommendations when disease pressure warrants treatment."
        ),
        "prevention": (
            "Use resistant hybrids where available, rotate crops, manage "
            "crop residue appropriately, and monitor lower leaves early."
        )
    },

    "Corn___Common_rust": {
        "disease": "Common Rust",
        "crop": "Corn",
        "severity": "Moderate",
        "explanation": (
            "Model detected Common rust on Corn. "
            "The disease forms reddish-brown rust pustules on leaf surfaces."
        ),
        "recommendations": (
            "Monitor disease progression and consider locally approved "
            "fungicide management when infection becomes severe."
        ),
        "prevention": (
            "Use resistant hybrids where available and regularly inspect "
            "leaves during favorable weather conditions."
        )
    },

    "Corn___Northern_Leaf_Blight": {
        "disease": "Northern Leaf Blight",
        "crop": "Corn",
        "severity": "High",
        "explanation": (
            "Model detected Northern leaf blight on Corn. "
            "The disease produces long, gray-green to tan lesions on leaves."
        ),
        "recommendations": (
            "Monitor disease spread and follow locally approved fungicide "
            "recommendations for severe infections."
        ),
        "prevention": (
            "Use resistant hybrids, rotate crops where practical, "
            "and manage infected crop residue."
        )
    },

    "Corn___healthy": {
        "disease": "Healthy",
        "crop": "Corn",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Corn foliage with no major disease "
            "symptoms represented by the PlantVillage model."
        ),
        "recommendations": (
            "Continue standard irrigation, nutrition, and crop monitoring."
        ),
        "prevention": (
            "Maintain field sanitation and regularly inspect leaves "
            "for early disease symptoms."
        )
    },


    # ========================================================
    # GRAPE
    # ========================================================

    "Grape___Black_rot": {
        "disease": "Black Rot",
        "crop": "Grape",
        "severity": "High",
        "explanation": (
            "Model detected Black rot on Grape. "
            "The disease can produce brown circular leaf lesions and "
            "dark, shriveled fruit."
        ),
        "recommendations": (
            "Remove infected berries and plant debris. Improve canopy "
            "ventilation and follow locally approved fungicide recommendations."
        ),
        "prevention": (
            "Maintain vineyard sanitation, prune dense growth, and avoid "
            "conditions that keep foliage and fruit wet for long periods."
        )
    },

    "Grape___Esca_(Black_Measles)": {
        "disease": "Esca (Black Measles)",
        "crop": "Grape",
        "severity": "High",
        "explanation": (
            "Model detected Esca (Black Measles) on Grape. "
            "Symptoms may include leaf discoloration and characteristic "
            "dark spotting on berries."
        ),
        "recommendations": (
            "Remove severely affected plant material and consult local "
            "grape disease management guidelines."
        ),
        "prevention": (
            "Use healthy planting material, minimize pruning wounds, "
            "and maintain vineyard sanitation."
        )
    },

    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": {
        "disease": "Leaf Blight",
        "crop": "Grape",
        "severity": "Moderate",
        "explanation": (
            "Model detected Leaf blight on Grape. "
            "The disease produces dark lesions on leaves that may expand "
            "under favorable conditions."
        ),
        "recommendations": (
            "Remove severely infected foliage and improve canopy ventilation. "
            "Use locally approved fungicide recommendations when required."
        ),
        "prevention": (
            "Maintain pruning and sanitation practices and avoid prolonged "
            "leaf wetness."
        )
    },

    "Grape___healthy": {
        "disease": "Healthy",
        "crop": "Grape",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Grape foliage with no major disease "
            "symptoms represented by the model."
        ),
        "recommendations": (
            "Continue regular irrigation, nutrition, pruning, and monitoring."
        ),
        "prevention": (
            "Maintain vineyard sanitation and good canopy airflow."
        )
    },


    # ========================================================
    # ORANGE
    # ========================================================

    "Orange___Haunglongbing_(Citrus_greening)": {
        "disease": "Huanglongbing (Citrus Greening)",
        "crop": "Orange",
        "severity": "High",
        "explanation": (
            "Model detected Huanglongbing (Citrus greening) on Orange. "
            "Typical symptoms include irregular leaf mottling, yellowing, "
            "and decline in plant vigor."
        ),
        "recommendations": (
            "Remove severely affected trees where recommended by local "
            "plant-health authorities and manage the insect vector using "
            "approved integrated pest management practices."
        ),
        "prevention": (
            "Use certified disease-free planting material, monitor for "
            "vector insects, and regularly inspect new flush growth."
        )
    },


    # ========================================================
    # PEACH
    # ========================================================

    "Peach___Bacterial_spot": {
        "disease": "Bacterial Spot",
        "crop": "Peach",
        "severity": "Moderate",
        "explanation": (
            "Model detected Bacterial spot on Peach. "
            "Symptoms may include small dark leaf lesions, shot-hole "
            "appearance, and spotting on fruit."
        ),
        "recommendations": (
            "Remove severely affected plant material and maintain good "
            "orchard sanitation. Follow locally approved bacterial disease "
            "management recommendations."
        ),
        "prevention": (
            "Use healthy planting material, avoid unnecessary overhead "
            "irrigation, and maintain good canopy ventilation."
        )
    },

    "Peach___healthy": {
        "disease": "Healthy",
        "crop": "Peach",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Peach foliage with no major disease "
            "symptoms represented by the model."
        ),
        "recommendations": (
            "Continue routine irrigation, nutrition, pruning, and monitoring."
        ),
        "prevention": (
            "Maintain orchard hygiene and regularly inspect leaves and fruit."
        )
    },


    # ========================================================
    # PEPPER
    # ========================================================

    "Pepper,_bell___Bacterial_spot": {
        "disease": "Bacterial Spot",
        "crop": "Pepper (Bell)",
        "severity": "Moderate",
        "explanation": (
            "Model detected Bacterial spot on Pepper (Bell). "
            "The disease can produce small dark or water-soaked lesions "
            "on leaves, stems, and fruit."
        ),
        "recommendations": (
            "Remove severely infected plant material and avoid spreading "
            "contaminated water or tools. Use locally approved bacterial "
            "disease management products according to their label."
        ),
        "prevention": (
            "Use disease-free seed and transplants, avoid overhead irrigation, "
            "sanitize tools, and remove infected crop debris."
        )
    },

    "Pepper,_bell___healthy": {
        "disease": "Healthy",
        "crop": "Pepper (Bell)",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Bell Pepper foliage without major "
            "disease symptoms represented by the model."
        ),
        "recommendations": (
            "Continue balanced irrigation, nutrition, and regular crop monitoring."
        ),
        "prevention": (
            "Maintain field sanitation, good spacing, and avoid prolonged "
            "leaf wetness."
        )
    },


    # ========================================================
    # POTATO
    # ========================================================

    "Potato___Early_blight": {
        "disease": "Early Blight",
        "crop": "Potato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Early blight on Potato. "
            "The disease commonly produces dark concentric lesions on "
            "older leaves."
        ),
        "recommendations": (
            "Remove severely affected foliage and manage crop residue. "
            "Use an appropriate locally approved fungicide when required."
        ),
        "prevention": (
            "Practice crop rotation, maintain plant nutrition, and avoid "
            "extended periods of leaf wetness."
        )
    },

    "Potato___Late_blight": {
        "disease": "Late Blight",
        "crop": "Potato",
        "severity": "High",
        "explanation": (
            "Model detected Late blight on Potato. "
            "The disease can cause rapidly expanding dark lesions and "
            "severe foliage damage under cool, humid conditions."
        ),
        "recommendations": (
            "Act quickly when symptoms appear. Remove severely infected "
            "material and follow locally approved late-blight fungicide "
            "management recommendations."
        ),
        "prevention": (
            "Use healthy seed material, monitor weather conditions, "
            "avoid prolonged leaf wetness, and maintain field sanitation."
        )
    },

    "Potato___healthy": {
        "disease": "Healthy",
        "crop": "Potato",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Potato foliage with no major disease "
            "symptoms represented by the model."
        ),
        "recommendations": (
            "Continue standard crop nutrition, irrigation, and monitoring."
        ),
        "prevention": (
            "Use healthy planting material and maintain good field sanitation."
        )
    },


    # ========================================================
    # RASPBERRY
    # ========================================================

    "Raspberry___healthy": {
        "disease": "Healthy",
        "crop": "Raspberry",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Raspberry foliage with no major disease "
            "symptoms represented by the model."
        ),
        "recommendations": (
            "Continue routine irrigation, nutrition, pruning, and monitoring."
        ),
        "prevention": (
            "Maintain field hygiene and good air circulation."
        )
    },


    # ========================================================
    # SOYBEAN
    # ========================================================

    "Soybean___healthy": {
        "disease": "Healthy",
        "crop": "Soybean",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Soybean foliage with no major disease "
            "symptoms represented by the model."
        ),
        "recommendations": (
            "Continue normal crop management and regularly monitor plant health."
        ),
        "prevention": (
            "Maintain proper field sanitation, crop nutrition, and adequate spacing."
        )
    },


    # ========================================================
    # SQUASH
    # ========================================================

    "Squash___Powdery_mildew": {
        "disease": "Powdery Mildew",
        "crop": "Squash",
        "severity": "Moderate",
        "explanation": (
            "Model detected Powdery mildew on Squash. "
            "The disease typically appears as white powdery growth "
            "on leaf surfaces."
        ),
        "recommendations": (
            "Remove severely affected leaves and improve air circulation. "
            "Use locally approved powdery mildew management products when needed."
        ),
        "prevention": (
            "Avoid excessive nitrogen, provide adequate spacing, and "
            "monitor leaves regularly."
        )
    },


    # ========================================================
    # STRAWBERRY
    # ========================================================

    "Strawberry___Leaf_scorch": {
        "disease": "Leaf Scorch",
        "crop": "Strawberry",
        "severity": "Moderate",
        "explanation": (
            "Model detected Leaf scorch on Strawberry. "
            "The disease can produce dark purple to brown spots that "
            "expand across leaf tissue."
        ),
        "recommendations": (
            "Remove severely affected leaves and maintain good field hygiene. "
            "Follow locally approved disease management recommendations."
        ),
        "prevention": (
            "Maintain proper spacing, remove infected debris, and avoid "
            "conditions that promote prolonged leaf wetness."
        )
    },

    "Strawberry___healthy": {
        "disease": "Healthy",
        "crop": "Strawberry",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Strawberry foliage without major "
            "disease symptoms represented by the model."
        ),
        "recommendations": (
            "Continue normal irrigation, nutrition, and crop monitoring."
        ),
        "prevention": (
            "Maintain field sanitation and adequate airflow around plants."
        )
    },


    # ========================================================
    # TOMATO
    # ========================================================

    "Tomato___Bacterial_spot": {
        "disease": "Bacterial Spot",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Bacterial spot on Tomato. "
            "The disease can produce small dark lesions on leaves, "
            "stems, and fruit."
        ),
        "recommendations": (
            "Remove severely infected plant material and avoid overhead "
            "irrigation. Follow locally approved bacterial disease "
            "management recommendations."
        ),
        "prevention": (
            "Use disease-free seed and transplants, sanitize tools, "
            "avoid working with wet plants, and remove infected debris."
        )
    },

    "Tomato___Early_blight": {
        "disease": "Early Blight",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Early blight on Tomato. "
            "Typical symptoms include dark concentric lesions on older "
            "leaves, often progressing upward through the plant."
        ),
        "recommendations": (
            "Remove severely affected leaves and improve plant airflow. "
            "Use locally approved fungicide management when necessary."
        ),
        "prevention": (
            "Practice crop rotation, maintain good plant spacing, "
            "mulch soil to reduce splash, and remove infected debris."
        )
    },

    "Tomato___Late_blight": {
        "disease": "Late Blight",
        "crop": "Tomato",
        "severity": "High",
        "explanation": (
            "Model detected Late blight on Tomato. "
            "The disease can cause rapidly expanding dark lesions on "
            "leaves and stems, particularly under cool and humid conditions."
        ),
        "recommendations": (
            "Remove severely infected plant material promptly and follow "
            "locally approved late-blight management recommendations."
        ),
        "prevention": (
            "Avoid prolonged leaf wetness, improve air circulation, "
            "monitor weather conditions, and remove infected debris."
        )
    },

    "Tomato___Leaf_Mold": {
        "disease": "Leaf Mold",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Leaf mold on Tomato. "
            "Yellowish patches may appear on the upper leaf surface with "
            "olive-green to brown fungal growth underneath."
        ),
        "recommendations": (
            "Improve ventilation and reduce humidity around the crop. "
            "Remove severely affected leaves and follow locally approved "
            "fungicide recommendations where necessary."
        ),
        "prevention": (
            "Avoid excessive humidity, improve greenhouse ventilation, "
            "provide adequate spacing, and avoid overhead irrigation."
        )
    },

    "Tomato___Septoria_leaf_spot": {
        "disease": "Septoria Leaf Spot",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Septoria leaf spot on Tomato. "
            "The disease commonly produces small circular leaf spots "
            "with darker margins and pale centers."
        ),
        "recommendations": (
            "Remove infected lower leaves and maintain field sanitation. "
            "Use locally approved fungicide management when required."
        ),
        "prevention": (
            "Avoid overhead irrigation, use mulch to reduce soil splash, "
            "and remove infected plant debris."
        )
    },

    "Tomato___Spider_mites Two-spotted_spider_mite": {
        "disease": "Two-Spotted Spider Mite Infestation",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Two-spotted spider mite infestation on Tomato. "
            "Feeding damage can cause yellow stippling, bronzing, and "
            "webbing on leaves during severe infestations."
        ),
        "recommendations": (
            "Monitor the undersides of leaves and use integrated pest "
            "management practices. Use an approved miticide only when "
            "necessary and according to its label."
        ),
        "prevention": (
            "Monitor regularly, avoid excessive plant stress, conserve "
            "beneficial predators, and maintain appropriate field conditions."
        )
    },

    "Tomato___Target_Spot": {
        "disease": "Target Spot",
        "crop": "Tomato",
        "severity": "Moderate",
        "explanation": (
            "Model detected Target spot on Tomato. "
            "The disease produces circular brown lesions that may develop "
            "concentric rings resembling a target."
        ),
        "recommendations": (
            "Remove severely affected foliage and improve canopy airflow. "
            "Follow locally approved fungicide recommendations when necessary."
        ),
        "prevention": (
            "Maintain good plant spacing, avoid prolonged leaf wetness, "
            "and remove infected crop debris."
        )
    },

    "Tomato___Tomato_Yellow_Leaf_Curl_Virus": {
        "disease": "Tomato Yellow Leaf Curl Virus",
        "crop": "Tomato",
        "severity": "High",
        "explanation": (
            "Model detected Tomato Yellow Leaf Curl Virus. "
            "Symptoms can include upward leaf curling, yellowing, "
            "stunted growth, and reduced fruit production."
        ),
        "recommendations": (
            "Remove severely infected plants where recommended and focus "
            "on management of the insect vector using integrated pest management."
        ),
        "prevention": (
            "Use healthy transplants, control whitefly populations, "
            "remove infected plants, and maintain field sanitation."
        )
    },

    "Tomato___Tomato_mosaic_virus": {
        "disease": "Tomato Mosaic Virus",
        "crop": "Tomato",
        "severity": "High",
        "explanation": (
            "Model detected Tomato mosaic virus. "
            "Symptoms can include mosaic-like light and dark green patterns, "
            "leaf distortion, and reduced plant growth."
        ),
        "recommendations": (
            "Remove infected plants and sanitize tools and hands before "
            "handling healthy plants. Follow local plant-health guidance."
        ),
        "prevention": (
            "Use certified disease-free seed, sanitize tools, avoid handling "
            "plants when wet, and remove infected plant debris."
        )
    },

    "Tomato___healthy": {
        "disease": "Healthy",
        "crop": "Tomato",
        "severity": "Low",
        "explanation": (
            "Model detected healthy Tomato foliage with no major disease "
            "symptoms represented by the PlantVillage model."
        ),
        "recommendations": (
            "Continue balanced irrigation, nutrition, and regular crop monitoring."
        ),
        "prevention": (
            "Maintain field sanitation, adequate spacing, and regular inspection "
            "for early signs of disease or pest infestation."
        )
    }
    
}
DEFAULT_DISEASE_METADATA = {

    "severity": "Moderate",

    "recommendations":
        "Consult the recommended crop disease management guidelines.",

    "prevention":
        "Maintain proper field hygiene and regularly monitor the crop."
}
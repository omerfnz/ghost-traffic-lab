package com.ghosttraffic.ghost_traffic_lab.engine.humanlike

data class SessionProfile(
    val seed: Long,
    val delay: GaussianDelay,
    val gesture: BezierGesture,
    val tremor: MicroTremor,
)

object SessionFingerprint {
    fun create(): SessionProfile {
        val seed = System.nanoTime()
        return SessionProfile(
            seed = seed,
            delay = GaussianDelay(seed),
            gesture = BezierGesture(seed + 1),
            tremor = MicroTremor(seed + 2),
        )
    }
}
